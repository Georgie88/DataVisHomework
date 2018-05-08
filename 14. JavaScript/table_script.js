
// Get references to the tbody element, input field and button
var tbody = document.querySelector("tbody");
var dateInput = document.querySelector("#date_time");
var stateInput = document.querySelector("#state");
var cityInput = document.querySelector("#city");
var countryInput = document.querySelector("#country");
var shapeInput = document.querySelector("#shape");
var searchBtn = document.querySelector("#search");
var loadMoreBtn = document.querySelector("#load-btn");

// Add an event listener to the searchButton, call handleSearchButtonClick when clicked
searchBtn.addEventListener("click", handleSearchButtonClick);

// Set filteredDates to data initially
var filteredDates = dataSet;
var startingINdex = 0;
var resultsPerPage = 25;

// renderTable renders the filteredDates to the tbody
function renderTableSection() {
    tbody.innerHTML = "";
    var endingIndex = startingINdex + resultsPerPage;
    var datesSubset = filteredDates.slice(startingINdex, endingIndex);
    for (var i = 0; i < datesSubset.length; i++) {
      // Get get the current ufo object and its fields
      var ufo = datesSubset[i];
      var fields = Object.keys(ufo);
      // Create a new row in the tbody, set the index to be i + startingIndex
      var row = tbody.insertRow(i);
      for (var j = 0; j < fields.length; j++) {
        // For every field in the ufo object, create a new cell at set its inner text to be the current value at the current ufo's field
        var field = fields[j];
        var cell = row.insertCell(j);
        cell.innerText = ufo[field];
      }
    }
  }


  function handleSearchButtonClick() {
    // Format the user's search by removing leading and trailing whitespace
    var filterDate = dateInput.value.trim();
    var filterState = stateInput.value.trim();
    var filterCity = cityInput.value.trim();
    var filterCountry = countryInput.value.trim();
    var filterShape = shapeInput.value.trim();
    // Set filteredDates to an array of all addresses whose "datetime" matches the filter
    filteredDates = dataSet.filter(function(ufo) {
        var ufoDate = ufo.datetime.substring(0, filterDate.length);
        var ufoCity = ufo.city.substring(0,filterCity.length).toLowerCase();
        var ufoState = ufo.state.substring(0, filterState.length).toLowerCase();
        var ufoCountry = ufo.country.substring(0, filterCountry.length).toLowerCase();
        var ufoShape = ufo.shape.substring(0, filterShape.length).toLowerCase();
        if (ufoDate === filterDate && ufoCity === filterCity && ufoState === filterState && ufoCountry === filterCountry && ufoShape === filterShape){
          return true;
        }
        return false;
    });
    renderTableSection();
  }
  // Render the table for the first time on page load
  renderTableSection();

  loadMoreBtn.addEventListener("click", handleButtonClick);

  function handleButtonClick() {
    startingINdex += resultsPerPage;
    
    // Check to see if there are any more results to render
    if (startingINdex + resultsPerPage >= filteredDates.length){
      loadMoreBtn.classList.add("disabled");
      loadMoreBtn.innerText = "All Data Loaded";
      loadMoreBtn.removeEventListener("click", handleButtonClick);
    
    }
    renderTableSection();
  }