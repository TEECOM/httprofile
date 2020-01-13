const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  theme: {
    extend: {
      colors: {
        'teecom-blue': '#1794CE'
      },
      fontFamily: {
        sans: ['Inter', ...defaultTheme.fontFamily.sans]
      },
      spacing: {
        '72': '18rem',
        '84': '21rem',
      }
    }
  },
  variants: {},
  plugins: []
}
