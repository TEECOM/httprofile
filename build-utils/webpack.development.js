const path = require("path");
const webpack = require('webpack');

module.exports = () => ({
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          { loader: 'elm-hot-webpack-loader' },
          {
            loader: 'elm-webpack-loader',
            options: {
              cwd: path.join(__dirname, '../'),
              debug: true
            }
          }
        ]
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader', 'postcss-loader']
      }
    ]
  },

  plugins: [
    new webpack.HotModuleReplacementPlugin(),
  ],

  devServer: {
    contentBase: './src',
    historyApiFallback: true,
    inline: true,
    stats: 'errors-only',
    hot: true,
  }
});
