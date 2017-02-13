var path = require('path');
var webpack = require('webpack')
module.exports = {
  entry: {
    rsvp: './client/rsvp.js',
    app: './web/static/js/app.js'
  },
  output: {
    filename: '[name].js',
    path: __dirname + '/priv/static/js',
    sourceMapFilename: '[name].map'
  },
  module: {
    rules: [
      {test: /\.js$/, use: 'babel-loader'}
    ]
  },
  devtool: 'cheap-module-source-map',
};
