<%@ Page Title="График стоимости токена" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TokensCost.aspx.cs" Inherits="Rentoolo.TokensCost" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.3.0/Chart.bundle.js"></script>

    <script>

        $(document).ready(function () {

            var result = <%=jsonTokensCosts %>;

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
                        mode: 'y'
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



    <div class="containerChart">
        <canvas id="examChart"></canvas>
    </div>

</asp:Content>
