// Build configuration for Bun
// Handles JavaScript bundling and CSS with Lightning CSS

const isProduction = process.env.MIX_ENV === 'prod'

// JavaScript build
const jsResult = await Bun.build({
  entrypoints: ['./assets/js/site.ts'],
  outdir: './_site/js',
  minify: isProduction,
  sourcemap: isProduction ? 'none' : 'inline',
  target: 'browser',
})

if (!jsResult.success) {
  console.error('JS build failed:', jsResult.logs)
  process.exit(1)
}

// CSS build with Lightning CSS
const { bundle } = await import('lightningcss')

const { code } = bundle({
  filename: './assets/css/site.css',
  minify: isProduction,
  sourceMap: !isProduction,
})

await Bun.write('./_site/css/site.css', code)

console.log(`Built assets (${isProduction ? 'production' : 'development'})`)
