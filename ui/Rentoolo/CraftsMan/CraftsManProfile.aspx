<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManProfile.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManProfile" %>

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
                <h1 class="bg-primary text-white"><%=craftsMan.FirstName %> <%=craftsMan.LastName %></h1>
                <h3 class="bg-warning text-white"><%=craftsMan.Сraft %></h3>
            </div>
        </div>
    </div>
    <div class="container blue-color">
        <div class="col">
            <div class="container">
                <h1 class="display-4 bg-danger text-white">Контакты</h1>
                <p class="lead"><%=craftsMan.Region %></p>
                <hr />
                <p class="lead"><%=craftsMan.Phone %></p>
                <hr />
                <p class="lead"><%=craftsMan.Email %></p>
                <hr />
            </div>
        </div>
    </div>
    <div class="media-body-inline-grid" data-grid="images">
        <div class="photoContainer" data='<%=craftsMan.ImgUrls%>'></div>
    </div>
    <div class="jumbotron jumbotron-fluid">
        <div class="container">
            <h1 class="display-4 bg-dark text-white">Немного о себе</h1>
            <p class="lead"><%=craftsMan.Description %></p>
        </div>
    </div>
    <div class="btn-group btn-group-lg" role="group" aria-label="Basic example">
        <a class="btn btn-outline-success" href="CraftsManConnection.aspx?id=<%= craftsMan.Id %>" role="button">Выбрать</a>
        <a class="btn btn-outline-danger" href="CraftsManPage.aspx" role="button">Другие варианты</a>
    </div>
</asp:Content>
