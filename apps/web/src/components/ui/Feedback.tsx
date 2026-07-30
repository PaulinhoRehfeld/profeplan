import React from 'react';
import { AlertCircle, CheckCircle2, Info, Loader2, SearchX } from 'lucide-react';

type FeedbackVariant = 'loading' | 'error' | 'success' | 'empty' | 'info';

export interface FeedbackProps extends React.HTMLAttributes<HTMLDivElement> {
  variant: FeedbackVariant;
  title: string;
  description?: string;
  action?: React.ReactNode;
}

const styles: Record<FeedbackVariant, { container: string; icon: React.ElementType }> = {
  loading: { container: 'border-blue-200 bg-blue-50 text-blue-900', icon: Loader2 },
  error: { container: 'border-red-200 bg-red-50 text-red-900', icon: AlertCircle },
  success: { container: 'border-green-200 bg-green-50 text-green-900', icon: CheckCircle2 },
  empty: { container: 'border-slate-200 bg-slate-50 text-slate-900', icon: SearchX },
  info: { container: 'border-sky-200 bg-sky-50 text-sky-900', icon: Info },
};

export const Feedback: React.FC<FeedbackProps> = ({
  variant,
  title,
  description,
  action,
  className = '',
  ...props
}) => {
  const config = styles[variant];
  const Icon = config.icon;
  const liveRole = variant === 'error' ? 'alert' : 'status';

  return (
    <div
      role={liveRole}
      aria-live={variant === 'error' ? 'assertive' : 'polite'}
      className={`rounded-[var(--ui-radius-panel)] border p-4 sm:p-5 ${config.container} ${className}`}
      {...props}
    >
      <div className="flex items-start gap-3">
        <Icon
          aria-hidden="true"
          className={`mt-0.5 h-5 w-5 shrink-0 ${variant === 'loading' ? 'animate-spin ui-reduce-motion' : ''}`}
        />
        <div className="min-w-0 flex-1">
          <p className="text-base font-semibold">{title}</p>
          {description && <p className="mt-1 text-sm leading-5 opacity-90">{description}</p>}
          {action && <div className="mt-3">{action}</div>}
        </div>
      </div>
    </div>
  );
};
