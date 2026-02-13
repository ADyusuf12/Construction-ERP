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
          textLight: "#1f2937",
          textDark: "#f3f4f6",
        },
      },
      keyframes: {
        fadeIn: {
          "0%": { opacity: "0", transform: "translateY(-10px)" },
          "100%": { opacity: "1", transform: "translateY(0)" },
        },
      },

      animation: {
        "fade-in": "fadeIn 0.3s ease-out forwards",
      },
    },
  },
  plugins: [],
}
