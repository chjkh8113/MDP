/**
 * IndexNow Integration for faster search engine indexing
 * https://www.indexnow.org/
 *
 * IndexNow instantly notifies search engines (Bing, Yandex, Seznam, Naver)
 * when content is created, updated, or deleted.
 */

const INDEXNOW_KEY = '98478c2ad8d8c94a6c79d97e1931beb0';
const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || 'https://mdp.ir';

// IndexNow endpoints - submitting to one notifies all participating search engines
const INDEXNOW_ENDPOINTS = [
  'https://api.indexnow.org/indexnow',
  'https://www.bing.com/indexnow',
];

export interface IndexNowResponse {
  success: boolean;
  message: string;
  submitted?: string[];
}

/**
 * Submit a single URL to IndexNow
 */
export async function submitUrlToIndexNow(url: string): Promise<IndexNowResponse> {
  return submitUrlsToIndexNow([url]);
}

/**
 * Submit multiple URLs to IndexNow (batch submission)
 * Maximum 10,000 URLs per request
 */
export async function submitUrlsToIndexNow(urls: string[]): Promise<IndexNowResponse> {
  if (urls.length === 0) {
    return { success: false, message: 'No URLs provided' };
  }

  if (urls.length > 10000) {
    return { success: false, message: 'Maximum 10,000 URLs per request' };
  }

  // Ensure all URLs are absolute
  const absoluteUrls = urls.map(url =>
    url.startsWith('http') ? url : `${SITE_URL}${url.startsWith('/') ? '' : '/'}${url}`
  );

  const payload = {
    host: new URL(SITE_URL).host,
    key: INDEXNOW_KEY,
    keyLocation: `${SITE_URL}/${INDEXNOW_KEY}.txt`,
    urlList: absoluteUrls,
  };

  try {
    // Submit to first endpoint (all IndexNow partners share submissions)
    const response = await fetch(INDEXNOW_ENDPOINTS[0], {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      body: JSON.stringify(payload),
    });

    // IndexNow returns 200, 202 for success
    if (response.ok || response.status === 202) {
      return {
        success: true,
        message: `Successfully submitted ${absoluteUrls.length} URL(s) to IndexNow`,
        submitted: absoluteUrls,
      };
    }

    // Handle specific error codes
    if (response.status === 400) {
      return { success: false, message: 'Invalid request format' };
    }
    if (response.status === 403) {
      return { success: false, message: 'Invalid key or key not found' };
    }
    if (response.status === 422) {
      return { success: false, message: 'Invalid URL format in request' };
    }
    if (response.status === 429) {
      return { success: false, message: 'Too many requests - rate limited' };
    }

    return {
      success: false,
      message: `IndexNow returned status ${response.status}`,
    };
  } catch (error) {
    console.error('IndexNow submission error:', error);
    return {
      success: false,
      message: error instanceof Error ? error.message : 'Unknown error',
    };
  }
}

/**
 * Get all important URLs that should be indexed
 */
export function getImportantUrls(): string[] {
  return [
    '/',
    '/fields',
    '/vocabulary',
    '/vocabulary/quiz',
  ];
}

/**
 * Submit all important site URLs to IndexNow
 * Call this after major content updates
 */
export async function submitSiteToIndexNow(): Promise<IndexNowResponse> {
  const urls = getImportantUrls();
  return submitUrlsToIndexNow(urls);
}
