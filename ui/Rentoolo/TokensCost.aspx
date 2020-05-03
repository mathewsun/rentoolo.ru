<%@ Page Title="График стоимости токена" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TokensCost.aspx.cs" Inherits="Rentoolo.TokensCost" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


    <script>

        $(document).ready(function () {


            $.get("api/GetTokensCost", function (data) {
               // $("#result").html(JSON.stringify(data));


                google.charts.load('current', { packages: ['corechart', 'line'] });
                google.charts.setOnLoadCallback(drawBasic);

                function drawBasic() {

                    var data = new google.visualization.DataTable();
                    data.addColumn('date', 'X');
                    data.addColumn('number', 'Cost');

                    


                    var ttt = [{ "Id": 1, "Value": 0.10007191, "Date": "2020-01-19T01:00:01.667" }, { "Id": 2, "Value": 0.100143871710481, "Date": "2020-01-20T01:00:01.667" }, { "Id": 3, "Value": 0.100215885168628, "Date": "2020-01-21T01:00:01.667" }];

                    var ttt2 = [[new Date(2000, 8, 5), 0.10007191], [new Date(2000, 9, 5), 0.100143871710481], [new Date(2000, 10, 5), 0.100215885168628]];

                    data.addRows(ttt2);


                    var options = {
                        hAxis: {
                            title: 'Date'
                        },
                        vAxis: {
                            title: 'Cost'
                        }
                    };

                    var chart = new google.visualization.LineChart(document.getElementById('chart_div'));

                    chart.draw(data, options);
                }

            });





















<%--            var result = <%=jsonTokensCosts %>;

            var chartDates = result.map(function(item) {
                return item.Date.split('T')[0];
            });

            var chartValues = result.map(function(item) {
                
                var result = {
                    t: new Date(item.Date.split('T')[0]),
                    y: item.Value
                };
                
                return result;
            });

            var ctx = document.getElementById("examChart").getContext("2d");

            var timeFormat = 'DD/MM/YYYY';

            var myChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: chartDates,
                    datasets: [{
                        label: 'Token cost',
                        data: chartValues,
                        backgroundColor: [
                          'rgba(255, 99, 132, 0.2)'
                        ],
                        borderColor: [
                          'rgba(255,99,132,1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    title:      {
                        display: true,
                        text:    "Стоимость токена Rentoolo"
                    },
                    tooltips: {
                        callbacks: {
                            title: function(tooltipItem, data) {
                                return data['labels'][tooltipItem[0]['index']];
                            },
                            label: function(tooltipItem, data) {
                                return data['datasets'][0]['data'][tooltipItem['index']];
                            },
                            afterLabel: function(tooltipItem, data) {
                                var dataset = data['datasets'][0];
                                var percent = Math.round((dataset['data'][tooltipItem['index']] / dataset["_meta"][0]['total']) * 100)
                                return '(' + percent + '%)';
                            }
                        },
                        backgroundColor: '#FFF',
                        titleFontSize: 16,
                        titleFontColor: '#0066ff',
                        bodyFontColor: '#000',
                        bodyFontSize: 14,
                        displayColors: false
                    },
                    scales:     {
                        xAxes: [{
                            
                        }],
                        yAxes: [{
                            scaleLabel: {
                                display:     true,
                                labelString: 'Цена (коп.)'
                            }
                        }]
                    }
                }
            });--%>

        });

    </script>

    <style>
        .containerChart {
            /*width: 500px;
            height: 500px;
            padding-top: 0px;*/
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="result"></div>


    <div id="chart_div"></div>
  
</asp:Content>
