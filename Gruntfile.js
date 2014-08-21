module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    // Lint definitions
    jshint: {
      files: ["app/assets/javascripts/clear_cms/*.js"],
      options: {
        jshintrc: ".jshintrc"
      }
    }
  });

  // Load the plugins
  grunt.loadNpmTasks("grunt-contrib-jshint");

  // Default task(s).
  grunt.registerTask("default", ["jshint"]);

};
