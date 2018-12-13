function importAll(r) {
  r.keys().forEach(r);
}

importAll(require.context('../favicons/', false, /\.(png|ico)$/))
