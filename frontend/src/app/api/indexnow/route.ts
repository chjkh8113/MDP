import { NextRequest, NextResponse } from 'next/server';
import { submitUrlsToIndexNow, submitSiteToIndexNow } from '@/lib/indexnow';

/**
 * POST /api/indexnow
 * Submit URLs to IndexNow for faster search engine indexing
 *
 * Body options:
 * - { urls: string[] } - Submit specific URLs
 * - { all: true } - Submit all important site URLs
 *
 * Note: This endpoint should be protected in production
 */
export async function POST(request: NextRequest) {
  try {
    const body = await request.json();

    // Option 1: Submit all important URLs
    if (body.all === true) {
      const result = await submitSiteToIndexNow();
      return NextResponse.json(result, {
        status: result.success ? 200 : 400,
      });
    }

    // Option 2: Submit specific URLs
    if (Array.isArray(body.urls) && body.urls.length > 0) {
      const result = await submitUrlsToIndexNow(body.urls);
      return NextResponse.json(result, {
        status: result.success ? 200 : 400,
      });
    }

    return NextResponse.json(
      { success: false, message: 'Provide either { urls: [...] } or { all: true }' },
      { status: 400 }
    );
  } catch (error) {
    console.error('IndexNow API error:', error);
    return NextResponse.json(
      { success: false, message: 'Invalid request body' },
      { status: 400 }
    );
  }
}

/**
 * GET /api/indexnow
 * Returns IndexNow configuration info (for debugging)
 */
export async function GET() {
  return NextResponse.json({
    enabled: true,
    keyLocation: '/98478c2ad8d8c94a6c79d97e1931beb0.txt',
    endpoints: [
      'https://api.indexnow.org/indexnow',
      'https://www.bing.com/indexnow',
    ],
    usage: {
      submitAll: 'POST /api/indexnow with { "all": true }',
      submitUrls: 'POST /api/indexnow with { "urls": ["/page1", "/page2"] }',
    },
  });
}
