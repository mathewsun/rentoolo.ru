<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManTaskDetails.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManTaskDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <link href="/assets/css/jQuery.Brazzers-Carousel.css" rel="stylesheet">
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>
    <script>
        $(document).ready(function () {
            $(".photoContainer").each(function (index) {
                var htmlString = '';
                var imgUrls = $(this).attr("data");
                JSON.parse(imgUrls,
                    function (k, v) {
                        if (k != "") {
                            htmlString += "<img src='" + v + "' style='height: 600px; width: 700px;' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();

        });
    </script>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container">
        <div class="row">
            <div class="col">
            </div>
            <div class="col order-12">
                <h1 class="bg-warning text-white"><%=order.NameTask %></h1>
            </div>
        </div>
    </div>

    <hr />
    <div class="jumbotron jumbotron-fluid">
        <div class="container">
            <h1 class="display-4">Детали задания</h1>
            <p class="lead"><%=order.Description %></p>

        </div>

    </div>
    <hr />
    <div class="media-body-inline-grid" data-grid="images">
        <div class="photoContainer" data='<%=order.ImgUrls%>'></div>
    </div>
    <hr />
    <div class="container blue-color">
        <div class="col">
            <div class="container">
                <h1 class="display-4 bg-danger text-white">Контакты</h1>
                <h1 class="bg-primary text-white">Заказчик: <%=order.FirstName %> <%=order.LastName %></h1>
                <p class="lead"><%=order.Region %></p>
                <hr />
                <p class="lead"><%=order.Phone %></p>
                <hr />
                <p class="lead"><%=order.Email %></p>
                <hr />
            </div>
        </div>
    </div>
    <div class="btn-group btn-group-lg" role="group" aria-label="Basic example">
        <a class="btn btn-outline-success" href="CraftsManConnection.aspx?id=<%= order.Id %>" role="button">Выбрать</a>
        <a class="btn btn-outline-danger" href="CraftsManTasks.aspx" role="button">Другие варианты</a>
    </div>
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/chart.js"></script>
    <script src="js/toolkit.js"></script>
    <script src="js/application.js"></script>
    <script>
        // execute/clear BS loaders for docs
        $(function () { while (window.BS && window.BS.loader && window.BS.loader.length) { (window.BS.loader.pop())() } })
    </script>

</asp:Content>

