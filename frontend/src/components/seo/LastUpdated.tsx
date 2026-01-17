import { CalendarDays, RefreshCw } from 'lucide-react';

interface LastUpdatedProps {
  // Content date - when the actual content was created/updated (e.g., konkur year)
  contentDate?: string;
  // Database date - when the data was last synced/updated
  lastModified?: string;
  // Custom label
  label?: string;
  // Show icon
  showIcon?: boolean;
  // Compact style
  compact?: boolean;
}

/**
 * Formats date for display in Persian
 * Accepts ISO date strings or Persian year numbers
 */
function formatDate(date: string | number): string {
  if (typeof date === 'number') {
    // Persian year (e.g., 1403)
    return `${date}`;
  }

  // ISO date string
  const d = new Date(date);
  if (isNaN(d.getTime())) return date;

  // Convert to Persian calendar date string
  return d.toLocaleDateString('fa-IR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  });
}

/**
 * Returns ISO date string for schema.org
 */
export function toISODate(date: string | number): string {
  if (typeof date === 'number') {
    // Convert Persian year to approximate Gregorian date
    // Persian year 1403 ≈ 2024, 1404 ≈ 2025, etc.
    const gregorianYear = date + 621;
    return `${gregorianYear}-03-21`; // Start of Persian year
  }

  const d = new Date(date);
  if (isNaN(d.getTime())) return new Date().toISOString().split('T')[0];
  return d.toISOString().split('T')[0];
}

/**
 * Component to display last updated date prominently for E-E-A-T
 */
export function LastUpdated({
  contentDate,
  lastModified,
  label = 'آخرین بروزرسانی',
  showIcon = true,
  compact = false,
}: LastUpdatedProps) {
  // Use the most recent date available
  const displayDate = lastModified || contentDate;

  if (!displayDate) return null;

  if (compact) {
    return (
      <span className="inline-flex items-center gap-1.5 text-xs text-gray-500">
        {showIcon && <RefreshCw className="w-3 h-3" />}
        <span>{label}: {formatDate(displayDate)}</span>
      </span>
    );
  }

  return (
    <div className="flex items-center gap-2 text-sm text-gray-600 bg-gray-50 rounded-lg px-3 py-2">
      {showIcon && <CalendarDays className="w-4 h-4 text-gray-400" />}
      <span>
        <span className="text-gray-500">{label}:</span>{' '}
        <time dateTime={toISODate(displayDate)} className="font-medium text-gray-700">
          {formatDate(displayDate)}
        </time>
      </span>
    </div>
  );
}

/**
 * Schema.org dateModified component for structured data
 */
interface DateModifiedSchemaProps {
  dateModified: string | number;
  datePublished?: string | number;
}

export function DateModifiedSchema({ dateModified, datePublished }: DateModifiedSchemaProps) {
  const schema: Record<string, string> = {
    "@context": "https://schema.org",
    "@type": "WebPage",
    "dateModified": toISODate(dateModified),
  };

  if (datePublished) {
    schema.datePublished = toISODate(datePublished);
  }

  return (
    <script
      type="application/ld+json"
      dangerouslySetInnerHTML={{ __html: JSON.stringify(schema) }}
    />
  );
}
