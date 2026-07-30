import React from 'react';

export interface CardProps extends React.HTMLAttributes<HTMLElement> {
  as?: 'article' | 'section' | 'div';
}

export const Card: React.FC<CardProps> = ({
  as: Element = 'article',
  className = '',
  ...props
}) => (
  <Element
    className={`rounded-[var(--ui-radius-panel)] border border-slate-200 bg-white ${className}`}
    {...props}
  />
);

export const CardHeader: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
  className = '',
  ...props
}) => <div className={`px-5 pt-5 sm:px-6 sm:pt-6 ${className}`} {...props} />;

export const CardBody: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
  className = '',
  ...props
}) => <div className={`p-5 sm:p-6 ${className}`} {...props} />;

export const CardFooter: React.FC<React.HTMLAttributes<HTMLDivElement>> = ({
  className = '',
  ...props
}) => <div className={`border-t border-slate-100 px-5 py-4 sm:px-6 ${className}`} {...props} />;
