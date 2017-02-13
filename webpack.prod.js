var webpack = require('webpack')
var config = require('./webpack.config')
var ExtractTextPlugin = require("extract-text-webpack-plugin");
var CopyWebpackPlugin = require("copy-webpack-plugin");
var plugins = [
  new webpack.LoaderOptionsPlugin({
    minimize: true,
    debug: false
  }),
  new webpack.DefinePlugin({
    'process.env.NODE_ENV': JSON.stringify('production')
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
  }),
  new ExtractTextPlugin("css/app.css"),
  new CopyWebpackPlugin([{ from: "./web/static/assets" }])
]
config.plugins = plugins;
delete config.devtool
module.exports = config;