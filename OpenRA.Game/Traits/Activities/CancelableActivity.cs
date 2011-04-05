﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace OpenRA.Traits.Activities
{
	public class Activity
	{
		public Activity NextActivity { get; set; }
		protected bool IsCanceled { get; private set; }

		public virtual Activity Tick( Actor self )
		{
			return this;	
		}
		protected virtual bool OnCancel( Actor self ) { return true; }

		public virtual void Cancel( Actor self )
		{
			IsCanceled = OnCancel( self );
			if( IsCanceled )
				NextActivity = null;
			else if (NextActivity != null)
				NextActivity.Cancel( self );
		}

		public virtual void Queue( Activity activity )
		{
			if( NextActivity != null )
				NextActivity.Queue( activity );
			else
				NextActivity = activity;
		}

		public virtual IEnumerable<Target> GetTargetQueue( Actor self )
		{
			yield break;
		}
	}
}
