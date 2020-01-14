const path = require('path');
const webpackMerge = require('webpack-merge');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin')

const modeConfig = env => require(`./build-utils/webpack.${env}`)(env);
const presetConfig = require("./build-utils/loadPresets");

module.exports = ({ mode, presets } = { mode: "production", presets: [] }) => {
  console.log(`Building for: ${mode}`);

  return webpackMerge(
    {
      mode,
      entry: path.join(__dirname, './src/frontend/index.js'),
      plugins: [
        new HtmlWebpackPlugin({
          template: 'src/frontend/assets/index.html',
          inject: 'body',
          filename: 'index.html',
        }),
        new CopyWebpackPlugin([
          { from: 'src/frontend/assets/favicon.png' }
        ]),
      ]
    },
    modeConfig(mode),
    presetConfig({ mode, presets }),
  )
};
