<%@ Page Title="График стоимости токена" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TokensCost.aspx.cs" Inherits="Rentoolo.TokensCost" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>


    <script>

        $(document).ready(function () {

            $.get("api/GetTokensCost", function (data) {
                // $("#result").html(JSON.stringify(data));

                var convertedData = [];

                data.forEach(element => {

                    var chartElement = [new Date(element.Date), element.Value]

                    convertedData.push(chartElement);
                });

                google.charts.load('current', { packages: ['corechart', 'line'] });
                google.charts.setOnLoadCallback(drawBasic);

                function drawBasic() {

                    var data = new google.visualization.DataTable();
                    data.addColumn('date', 'X');
                    data.addColumn('number', 'Cost');

                    data.addRows(convertedData);

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

    <h2>Стоимость токена</h2>

    <div id="chart_div"></div>

</asp:Content>
