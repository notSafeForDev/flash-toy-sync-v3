const rangemaxSlider = document.getElementById("rangemax");
const rangeminSlider = document.getElementById("rangemin");
const speedSlider = document.getElementById("speed");

rangemaxSlider.addEventListener("change", updateSliders);
rangeminSlider.addEventListener("change", updateSliders);
speedSlider.addEventListener("change", updateSliders);

function updateSliders(event)
{
  let values = {
    range: [rangeminSlider.value, rangemaxSlider.value],
    speed: speedSlider.value
  };
  ipcRenderer.updateRangeValues(values);
}
