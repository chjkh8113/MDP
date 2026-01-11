import { test, expect } from '@playwright/test';

test.describe('Vocabulary Flashcard System', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/vocabulary');
  });

  test('should load vocabulary page', async ({ page }) => {
    // Wait for page to load
    await expect(page.getByRole('heading', { name: /Vocabulary Practice/i })).toBeVisible();
  });

  test('should display stats cards', async ({ page }) => {
    // Wait for stats to load (check for streak icon)
    await page.waitForTimeout(2000);

    // Check for stats cards
    const streakCard = page.locator('text=Streak');
    await expect(streakCard).toBeVisible();

    const wordsCard = page.locator('text=Words Due');
    await expect(wordsCard).toBeVisible();

    const learnedCard = page.locator('text=Learned');
    await expect(learnedCard).toBeVisible();

    const xpCard = page.locator('text=XP');
    await expect(xpCard).toBeVisible();
  });

  test('should display flashcard with English word', async ({ page }) => {
    await page.waitForTimeout(2000);

    // Check for English text on card
    const englishLabel = page.locator('text=English');
    await expect(englishLabel).toBeVisible();
  });

  test('should flip card when clicked', async ({ page }) => {
    await page.waitForTimeout(2000);

    // Wait for card to be visible
    const card = page.locator('.perspective-1000');
    await expect(card).toBeVisible();

    // Click to flip
    await card.click();

    // Wait for animation
    await page.waitForTimeout(600);

    // Check for Persian label (back of card)
    const persianLabel = page.locator('text=Persian');
    await expect(persianLabel).toBeVisible();
  });

  test('should show rating buttons after flip', async ({ page }) => {
    await page.waitForTimeout(2000);

    // Click card to flip
    const card = page.locator('.perspective-1000');
    await card.click();

    await page.waitForTimeout(600);

    // Check for rating buttons
    const againBtn = page.getByRole('button', { name: /Again/i });
    const hardBtn = page.getByRole('button', { name: /Hard/i });
    const goodBtn = page.getByRole('button', { name: /Good/i });
    const easyBtn = page.getByRole('button', { name: /Easy/i });

    await expect(againBtn).toBeVisible();
    await expect(hardBtn).toBeVisible();
    await expect(goodBtn).toBeVisible();
    await expect(easyBtn).toBeVisible();
  });

  test('should advance to next card after rating', async ({ page }) => {
    await page.waitForTimeout(2000);

    // Get first word
    const firstWord = await page.locator('.perspective-1000 h2').first().textContent();

    // Flip card
    const card = page.locator('.perspective-1000');
    await card.click();
    await page.waitForTimeout(600);

    // Click Good button
    const goodBtn = page.getByRole('button', { name: /Good/i });
    await goodBtn.click();

    // Wait for next card animation
    await page.waitForTimeout(1500);

    // Check progress indicator changed
    const progressText = page.locator('text=/2 \\/ /');
    await expect(progressText).toBeVisible();
  });

  test('should show session complete when all cards reviewed', async ({ page }) => {
    await page.waitForTimeout(2000);

    // Review all cards quickly
    for (let i = 0; i < 10; i++) {
      const card = page.locator('.perspective-1000');
      if (await card.isVisible()) {
        await card.click();
        await page.waitForTimeout(300);

        const goodBtn = page.getByRole('button', { name: /Good/i });
        if (await goodBtn.isVisible()) {
          await goodBtn.click();
          await page.waitForTimeout(1000);
        }
      }
    }

    // Check for completion message or no more cards
    const completionOrEmpty = page.locator('text=Session Complete').or(page.locator('text=No Words to Study'));
    await expect(completionOrEmpty).toBeVisible({ timeout: 15000 });
  });
});

test.describe('Vocabulary API Integration', () => {
  test('should fetch vocabulary categories', async ({ request }) => {
    const response = await request.get('http://localhost:8181/api/v1/vocabulary/categories');
    expect(response.ok()).toBeTruthy();

    const data = await response.json();
    expect(Array.isArray(data)).toBeTruthy();
    expect(data.length).toBeGreaterThan(0);
    expect(data[0]).toHaveProperty('name_en');
    expect(data[0]).toHaveProperty('name_fa');
  });

  test('should fetch vocabulary words', async ({ request }) => {
    const response = await request.get('http://localhost:8181/api/v1/vocabulary/words');
    expect(response.ok()).toBeTruthy();

    const data = await response.json();
    expect(data).toHaveProperty('words');
    expect(data).toHaveProperty('total');
    expect(data.words.length).toBeGreaterThan(0);
    expect(data.words[0]).toHaveProperty('word_en');
    expect(data.words[0]).toHaveProperty('meaning_fa');
  });

  test('should fetch study queue', async ({ request }) => {
    const response = await request.get('http://localhost:8181/api/v1/vocabulary/study?limit=5');
    expect(response.ok()).toBeTruthy();

    const data = await response.json();
    expect(data).toHaveProperty('queue');
    expect(data).toHaveProperty('total');
    expect(data).toHaveProperty('due_count');
    expect(data).toHaveProperty('new_count');
  });

  test('should submit word review', async ({ request }) => {
    // First get a word
    const wordsResponse = await request.get('http://localhost:8181/api/v1/vocabulary/words?limit=1');
    const wordsData = await wordsResponse.json();
    const wordId = wordsData.words[0].id;

    // Submit review
    const response = await request.post('http://localhost:8181/api/v1/vocabulary/review', {
      data: {
        word_id: wordId,
        quality: 4,
      },
    });
    expect(response.ok()).toBeTruthy();

    const data = await response.json();
    expect(data).toHaveProperty('success');
    expect(data.success).toBeTruthy();
    expect(data).toHaveProperty('next_review');
    expect(data).toHaveProperty('xp_earned');
  });

  test('should fetch vocabulary stats', async ({ request }) => {
    const response = await request.get('http://localhost:8181/api/v1/vocabulary/stats');
    expect(response.ok()).toBeTruthy();

    const data = await response.json();
    expect(data).toHaveProperty('total_words');
    expect(data).toHaveProperty('words_learned');
    expect(data).toHaveProperty('current_streak');
    expect(data).toHaveProperty('total_xp');
  });
});
