using System;   
using System.IO;
using System.Management.Automation;
using System.Management.Automation.Host;
using System.Collections.ObjectModel;
using Ionic.Zip;

namespace PSIonicTools
{

    public enum Actions : int
    {
        Automatic,
        Interactive
    }

    public class PSVerboseTextWriter : StringWriter
    {
        private EngineIntrinsics ExecutionContext;

        public PSVerboseTextWriter(EngineIntrinsics Context)
            : base()
        {
            //L'instance peut accéder à la session Powershell
            ExecutionContext = Context;
        }

        public override void WriteLine(string value)
        {
            ExecutionContext.Host.UI.WriteVerboseLine(value);
        }
    }

    public class PSZipError
    {
        private EngineIntrinsics ExecutionContext;

        public PSZipError(EngineIntrinsics Context)
        {
            if (Context.Host.Name == "ServerRemoteHost")
            {
               //todo WorkFlow & DSC ?   todo a l'origine pour orchestrator
               //System.Management.Automation.CmdletInvocationException ?
              throw new InvalidOperationException(String.Format("This class need a ConsoleHost context. Job or remoting context is not permitted.",Context.Host.Name)); 
            }
            //L'instance peut accéder à la session Powershell
            ExecutionContext = Context;
        }

         // Register-ObjectEvent ne fonctionne pas avec cet event. Bug ?
        public void SetZipErrorHandler(ZipFile Zip)
        {
            Zip.ZipError += this.PSIonicZipErrorHandler;
        }

        public void RemoveZipErrorHandler(ZipFile Zip)
        {
            Zip.ZipError -= this.PSIonicZipErrorHandler;
        }

        //Est déclenché en cas d'erreur lors de l'appel de la méthode Save()
        private void PSIonicZipErrorHandler(object sender, ZipErrorEventArgs e)
        {
            ZipEntry entry = e.CurrentEntry;
            int response = 0;
            
            Collection<ChoiceDescription> choices= new Collection<ChoiceDescription>();
            choices.Add(new ChoiceDescription("&Retry","Retry the operation"));
            choices.Add(new ChoiceDescription("&Skip","Retry the operation"));
            choices.Add(new ChoiceDescription("&Throw","Abort with an exception"));
            choices.Add(new ChoiceDescription("&Cancel","Cancel the operation"));
            response = ExecutionContext.Host.UI.PromptForChoice(
                         string.Format("Error saving '{0}' : {1} ", e.FileName, e.Exception.Message),
                         string.Format("Select an action for this entry '{0}'", e.CurrentEntry.FileName), 
                         choices, 
                         1);

            switch (response)
            {
               case 0 : entry.ZipErrorAction = ZipErrorAction.Retry;break;
               case 1 : entry.ZipErrorAction = ZipErrorAction.Skip; break;
               case 2 : entry.ZipErrorAction = ZipErrorAction.Throw; break;
               case 3 : e.Cancel = true; break;
            }
        }
    }
    
    public class PSZipReadProgress
    {
        private EngineIntrinsics ExecutionContext;
        
        private int Count=0;
	    private int activityId;
	    private string activity;

        public PSZipReadProgress(EngineIntrinsics Context,
                              	 int ActivityId,
                              	 string Activity)
        {
            activityId=ActivityId;
	        activity=Activity;
            
            if (Context.Host.Name == "ServerRemoteHost")
            {
               //todo WorkFlow & DSC ?
               //ExecutionContext.Host.UI : null indicates that the host does not support user interaction.
               //todo http://stackoverflow.com/questions/3996958/write-error-write-in-powershell-used-in-c-works-but-write-debug-doesnt-wo
                
              throw new InvalidOperationException(String.Format("This class need a ConsoleHost context. Job or remoting context is not permitted.",Context.Host.Name)); 
            }
            //L'instance peut accéder à la session Powershell
            ExecutionContext = Context;
        }

         // ZIp::Read ne permet pas de connaitre l'instance pour l'utilser avec Register-ObjectEvent.
        public void SetZipReadProgressHandler(ReadOptions Options)
        {
            Options.ReadProgress += this.PSIonicZipReadProgressHandler;
        }

        public void RemoveZipReadProgressHandler(ReadOptions Options)
        {
            Options.ReadProgress -= this.PSIonicZipReadProgressHandler;
        }

        //Est déclenché lors de la lecture d'un fichier ZIP ( ZipFile.Read() ) 
        private void PSIonicZipReadProgressHandler(object sender, ReadProgressEventArgs e)
        {
            ProgressRecord progress=null;
            //ExecutionContext.Host.UI.WriteWarningLine(e.EventType.ToString());
            ZipEntry entry = e.CurrentEntry;
            
            switch (e.EventType)
            {
                case ZipProgressEventType.Reading_BeforeReadEntry:
                   //Affiche uniquement le nombre d'entrée lues
                  progress = new ProgressRecord(activityId, activity, string.Format("Read {0}",e.EntriesTotal));
                  progress.RecordType = ProgressRecordType.Processing;
                  progress.PercentComplete =-1;

                  ExecutionContext.Host.UI.WriteProgress(1,progress);
                  break;  
                                  
                case ZipProgressEventType.Reading_AfterReadEntry:
                   //Affiche la progression de lecture
                  Count++;
                  progress = new ProgressRecord(activityId, activity, entry.FileName);
                  progress.RecordType = ProgressRecordType.Processing;
                  progress.PercentComplete =  (int) Math.Floor(((float) Count/ e.EntriesTotal)*100);

                  ExecutionContext.Host.UI.WriteProgress(1,progress);
                  break;  
                
                case ZipProgressEventType.Reading_Completed:
                   //clôt l'afffichage
                  progress = new ProgressRecord(activityId, activity, "end of file");
                  progress.RecordType = ProgressRecordType.Completed;
                  progress.PercentComplete =100;
                  Count=0;

                  ExecutionContext.Host.UI.WriteProgress(1,progress);
                  break;                  
            }
        }
    }

    //https://connect.microsoft.com/feedback/ViewFeedback.aspx?FeedbackID=307821&SiteID=99
    public class ZipPassword
    {
        public static void Reset(ZipFile Zip)
        {
            Zip.Password = null;
        }
    }

    [Serializable]
    public class PsionicException : System.ApplicationException
    {
       public PsionicException() : base()
       {
       }
       
       public PsionicException(string message) : base(message)
       {
       }
       
       public PsionicException(string message, Exception innerException)
       : base(message, innerException)
       {
       }
    }
    
    [Serializable]
    public class PsionicInvalidValueException :PsionicException 
    {
       private object value=null;
       public object Value 
       {
          get { return this.value; }
       }
       
       public PsionicInvalidValueException(object Value) : base()
       {
          value=Value;
       }
       
       public PsionicInvalidValueException(object Value,string message) : base(message)
       {
          value=Value;
       }
       
       public PsionicInvalidValueException(object Value,string message, Exception innerException)
        : base(message, innerException)
       {
          value=Value;
       }      
    }    
}

