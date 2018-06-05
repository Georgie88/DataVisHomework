//Setting up our chart
var svgWidth = 1000;
var svgHeight = 500;

var margin = { top: 20, right: 40, bottom: 80, left: 100 };

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

//Creating the SVG wrapper, append an SVG group that will hold the chart and set margins
var svg = d3
  .select(".chart")
  .append("svg")
  .attr("width", svgWidth)
  .attr("height", svgHeight)
  .append("g")
  .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

//Appending the SVG group
var chart = svg.append("g");

//Appending a div to the body and creating the tooltips class
d3.select(".chart").append("div").attr("class", "tooltip").style("opacity", 0);

//Importing the data from the CSV file
d3.csv("data final/data.csv", function(err, cencusData) {
  if (err) throw err;

    // console.log(cencusData);
  cencusData.forEach(function(data) {
    data.state = data.state;
    data.abbr = data.abbr;
    data.poverty = +data.poverty;
    data.healthcare = +data.healthcare;
    // console.log('abbr', data.abbr);
    
  });


  //Creating the scale functions
  var yLinearScale = d3.scaleLinear().range([height, 0]);

  var xLinearScale = d3.scaleLinear().range([0, width]);

  //Creating the axis functions
  var bottomAxis = d3.axisBottom(xLinearScale);
  var leftAxis = d3.axisLeft(yLinearScale);

  //Setting up some variables to store the minimum and maximum values
  var xMin;
  var xMax;
  var yMax;

  //This function helps to identifies the minimum and maximum values in a column to determine the axis 
  function findMinAndMax(dataColumnX) {
    xMin = d3.min(cencusData, function(data) {
      return +data[dataColumnX] * 0.8;
    });

    xMax = d3.max(cencusData, function(data) {
      return +data[dataColumnX] * 1.1;
    });

    yMax = d3.max(cencusData, function(data) {
      return +data.healthcare * 1.1;
    });
  }

  //Setting up the x-axis to poverty
  var currentAxisLabelX = "poverty";

  //Calling the function findMinAndMax() for poverty
  findMinAndMax(currentAxisLabelX);

  //Setting up the domain of an axis to extended it between min and max
  xLinearScale.domain([xMin, xMax]);
  yLinearScale.domain([0, yMax]);

  //Initializing the tooltip
  var toolTip = d3
    .tip()
    .attr("class", "tooltip")
    //Defining the position
    .offset([90, -60])
    //Setting up the callback function to interact html and JS together
   .html(function(data) {
      var state = data.state;
      var poverty = +data.poverty;
      var healthcare = +data.healthcare;
      return state  +
      "<br> " + 
      "Poverty: " + poverty + "%" +
      "<br>" +
      "Healthcare: " + healthcare + "%" ;
    }); 

  //Creating tooltip
  chart.call(toolTip);

  chart
    .selectAll("circle")
    .data(cencusData)
    .enter()
    .append("circle")
    .attr("class", "dot")
    .attr("cx", function(data, index) { return xLinearScale(+data[currentAxisLabelX]); })
    .attr("cy", function(data, index) { return yLinearScale(+data.healthcare); })
    .attr("r", "12")
    .attr("fill", '#e7547b')
    .on("mouseover", function(data) { toolTip.show(data); })
    .on("mouseout", function(data, index) { toolTip.hide(data); });

  chart.append("text")
    .style("text-anchor", "middle")
    .attr("class", "plot-text")    
    .selectAll("tspan")
    .data(cencusData)
    .enter()
    .append("tspan")
    .attr("x", function(data) { return xLinearScale(+data[currentAxisLabelX]); })
    .attr("y", function(data) { return yLinearScale(+data.healthcare - 0.2); })
    .text(function(data) { return data.abbr });

//Appending the SVG group for the x-axis and displaying them
  chart
    .append("g")
    .attr("transform", "translate(0," + height + ")")
    //Setting up the transition effects
    .attr("class", "x-axis")
    .call(bottomAxis);

  //Appending the group for y-axis and displaying them
  chart.append("g").call(leftAxis);

  //Appending the y-axis label
  chart
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 0 - margin.left + 40)
    .attr("x", 0 - height / 2)
    .attr("dy", "1em")
    .attr("class", "axis-text")
    .attr("data-axis-name", "num_hits")
    .text("Lacks Healthcare (%)");

  //Appending the x-axis labels
  chart
    .append("text")
    .attr(
      "transform",
      "translate(" + width / 2 + " ," + (height + margin.top + 20) + ")"
    )
    //Activating the axis
    .attr("class", "axis-text active")
    .attr("data-axis-name", "hair_length")
    .text("In Poverty (%)");

}); 