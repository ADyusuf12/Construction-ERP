module.exports = {
  content: [
    "./app/views/**/*.{html,erb}",
    "./app/helpers/**/*.rb",
    "./app/controllers/**/*.rb",
    "./app/assets/stylesheets/**/*.css",
    "./app/javascript/**/*.js"
  ],
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        hamzis: {
          brown: "#4e342e",
          black: "#212121",
          white: "#ffffff",
          copper: "#b87333",
          textLight: "#1f2937", // dark gray for light mode text
          textDark: "#f3f4f6",  // light gray for dark mode text
        },
      },
    },
  },
  plugins: [],
}
