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
        },
      },
    },
  },
  plugins: [],
}
