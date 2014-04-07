using System;
using System.Text;
using System.IO;
using System.Collections;
using log4net.Util;
using log4net.ObjectRenderer;
using System.Management.Automation;

namespace PSLog4NET
{
    public class PSObjectRenderer : PSObject,IObjectRenderer
    {
        #region IObjectRenderer Membres
        // $PSRenderer = new-object PSLog4NET.PSObjectRenderer
        // $Repository = [log4net.LogManager]::GetRepository()        
        // $Repository.RendererMap.Put([PSLog4NET.PSObjectRenderer],(new-object PSLog4NET.PSObjectRenderer) )
        //  # rver -> http://blogs.msdn.com/powershell/archive/2006/12/07/resolve-error.aspx
        // $PSRenderer|Add-Member -Force -MemberType ScriptMethod ToString { rver|Out-String }
        // trap {$Logger.Error($PSRenderer)}
        public void RenderObject(log4net.ObjectRenderer.RendererMap rendererMap, object obj, System.IO.TextWriter writer)
        {
		    if (rendererMap == null)
			{
				throw new ArgumentNullException("rendererMap");
			}

			if (obj == null)
			{
				writer.Write(SystemInfo.NullText);
				return;
			}
            PSObjectRenderer Instance = obj as PSObjectRenderer;
            if (Instance != null)
             //On laisse le scripteur redéclarer la méthode ToString à l'aide de Add-Member
            { writer.Write("{0}", Instance.ToString()); }
            else
            { writer.Write(SystemInfo.NullText); }
        }
        #endregion 
    }
    
}
