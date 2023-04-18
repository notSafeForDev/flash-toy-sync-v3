const { contextBridge, ipcRenderer } = require('electron')

contextBridge.exposeInMainWorld('ipcRenderer', {
  updateRangeValues: (values) => ipcRenderer.send('setSliderValues', values)
});
