const { createCanvas } = require('canvas');
const fs = require('fs');
const path = require('path');

// OG Image dimensions (standard: 1200x630)
const WIDTH = 1200;
const HEIGHT = 630;

const canvas = createCanvas(WIDTH, HEIGHT);
const ctx = canvas.getContext('2d');

// Background gradient (blue theme)
const gradient = ctx.createLinearGradient(0, 0, WIDTH, HEIGHT);
gradient.addColorStop(0, '#1e3a8a'); // blue-900
gradient.addColorStop(0.5, '#1d4ed8'); // blue-700
gradient.addColorStop(1, '#3b82f6'); // blue-500
ctx.fillStyle = gradient;
ctx.fillRect(0, 0, WIDTH, HEIGHT);

// Add subtle pattern overlay
ctx.globalAlpha = 0.1;
for (let i = 0; i < WIDTH; i += 40) {
  for (let j = 0; j < HEIGHT; j += 40) {
    ctx.beginPath();
    ctx.arc(i, j, 2, 0, Math.PI * 2);
    ctx.fillStyle = '#ffffff';
    ctx.fill();
  }
}
ctx.globalAlpha = 1;

// Logo text "MDP"
ctx.fillStyle = '#ffffff';
ctx.font = 'bold 120px Arial, sans-serif';
ctx.textAlign = 'center';
ctx.textBaseline = 'middle';
ctx.fillText('MDP', WIDTH / 2, HEIGHT / 2 - 80);

// Subtitle in Persian (using fallback for font)
ctx.font = 'bold 48px Arial, sans-serif';
ctx.fillStyle = '#e0e7ff'; // blue-100
ctx.fillText('آرشیو سوالات کنکور ارشد', WIDTH / 2, HEIGHT / 2 + 40);

// Tagline
ctx.font = '32px Arial, sans-serif';
ctx.fillStyle = '#93c5fd'; // blue-300
ctx.fillText('بانک جامع سوالات کارشناسی ارشد ایران', WIDTH / 2, HEIGHT / 2 + 110);

// Decorative elements - corner accents
ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
ctx.lineWidth = 3;

// Top-left corner
ctx.beginPath();
ctx.moveTo(40, 80);
ctx.lineTo(40, 40);
ctx.lineTo(80, 40);
ctx.stroke();

// Top-right corner
ctx.beginPath();
ctx.moveTo(WIDTH - 40, 80);
ctx.lineTo(WIDTH - 40, 40);
ctx.lineTo(WIDTH - 80, 40);
ctx.stroke();

// Bottom-left corner
ctx.beginPath();
ctx.moveTo(40, HEIGHT - 80);
ctx.lineTo(40, HEIGHT - 40);
ctx.lineTo(80, HEIGHT - 40);
ctx.stroke();

// Bottom-right corner
ctx.beginPath();
ctx.moveTo(WIDTH - 40, HEIGHT - 80);
ctx.lineTo(WIDTH - 40, HEIGHT - 40);
ctx.lineTo(WIDTH - 80, HEIGHT - 40);
ctx.stroke();

// Add website URL at bottom
ctx.font = '24px Arial, sans-serif';
ctx.fillStyle = 'rgba(255, 255, 255, 0.7)';
ctx.fillText('mdp.ir', WIDTH / 2, HEIGHT - 50);

// Save to file
const outputPath = path.join(__dirname, '..', 'public', 'og-image.png');
const buffer = canvas.toBuffer('image/png');
fs.writeFileSync(outputPath, buffer);

console.log('OG image generated successfully:', outputPath);
