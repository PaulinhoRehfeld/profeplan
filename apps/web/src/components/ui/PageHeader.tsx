import React from 'react';

export interface PageHeaderProps {
  title: string;
  description?: string;
  eyebrow?: string;
  actions?: React.ReactNode;
}

export const PageHeader: React.FC<PageHeaderProps> = ({ title, description, eyebrow, actions }) => (
  <header className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
    <div className="max-w-3xl">
      {eyebrow && <p className="mb-1 text-sm font-semibold text-blue-700">{eyebrow}</p>}
      <h1 className="text-3xl font-semibold leading-9 tracking-tight text-slate-950 sm:text-4xl sm:leading-10">
        {title}
      </h1>
      {description && <p className="mt-2 text-base leading-6 text-slate-600">{description}</p>}
    </div>
    {actions && <div className="flex shrink-0 flex-wrap gap-3">{actions}</div>}
  </header>
);
