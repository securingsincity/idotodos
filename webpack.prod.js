var webpack = require('webpack')
var config = require('./webpack.config')
var plugins = [
  new webpack.LoaderOptionsPlugin({
    minimize: true,
    debug: false
  }),
  new webpack.optimize.UglifyJsPlugin({
      beautify: false,
      mangle: {
          screw_ie8: true,
          keep_fnames: true
      },
      compress: {
          screw_ie8: true
      },
      comments: false
  })
]
config.plugins = plugins;
module.exports = config;