const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const erb =  require('./loaders/erb')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  $: 'jquery',
  jQuery: 'jquery',
  Popper: 'popper.js',
  moment: 'moment'
}))

environment.loaders.append('erb', erb)

module.exports = environment
