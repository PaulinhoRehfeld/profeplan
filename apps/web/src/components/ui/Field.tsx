import React, { useId } from 'react';

export interface FieldProps extends React.InputHTMLAttributes<HTMLInputElement> {
  label: string;
  description?: string;
  error?: string;
  containerClassName?: string;
}

export const Field = React.forwardRef<HTMLInputElement, FieldProps>(
  (
    {
      label,
      description,
      error,
      id,
      required,
      disabled,
      className = '',
      containerClassName = '',
      ...props
    },
    ref
  ) => {
    const generatedId = useId();
    const fieldId = id || generatedId;
    const descriptionId = description ? `${fieldId}-description` : undefined;
    const errorId = error ? `${fieldId}-error` : undefined;
    const describedBy = [descriptionId, errorId].filter(Boolean).join(' ') || undefined;

    return (
      <div className={`space-y-1.5 ${containerClassName}`}>
        <label htmlFor={fieldId} className="block text-sm font-semibold text-slate-800">
          {label}
          {required && (
            <span className="ml-1 text-red-700" aria-hidden="true">
              *
            </span>
          )}
        </label>
        {description && (
          <p id={descriptionId} className="text-sm text-slate-600">
            {description}
          </p>
        )}
        <input
          ref={ref}
          id={fieldId}
          required={required}
          disabled={disabled}
          aria-invalid={error ? true : undefined}
          aria-describedby={describedBy}
          className={`ui-focus-ring min-h-11 w-full rounded-[var(--ui-radius-control)] border bg-white px-3.5 py-2 text-base text-slate-900 placeholder:text-slate-400 disabled:cursor-not-allowed disabled:bg-slate-100 disabled:text-slate-500 ${error ? 'border-red-700' : 'border-slate-300'} ${className}`}
          {...props}
        />
        {error && (
          <p id={errorId} role="alert" className="text-sm font-medium text-red-700">
            {error}
          </p>
        )}
      </div>
    );
  }
);

Field.displayName = 'Field';
