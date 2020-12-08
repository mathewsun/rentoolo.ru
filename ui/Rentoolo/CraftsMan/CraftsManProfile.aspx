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
     <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Род трудовой деятельности:</span>
            </div>
            <div class="additem-right">
               <h1><%=craftsMan.Сraft %></h1>
                <h3><%=craftsMan.FirstName %> <%=craftsMan.LastName %></h3>
            </div>
        </div> 
    <div class="additem-left additem-contact">
        <div class="col">
            <div class="container">
                <h1 class="additem-title">Контакты</h1>
                <hr />
                <p class="lead"><%=craftsMan.Region %></p>
                <p class="lead"><%=craftsMan.Phone %></p>
                <p class="lead"><%=craftsMan.Email %></p>
            </div>
        </div>
    </div>
    <div class="media-body-inline-grid " data-grid="images">
        <div class="photoContainer" data='<%=craftsMan.ImgUrls%>'></div>
    </div>
     <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Немного о себе</span>
            </div>
            <div class="additem-right advert-description">
                <%=craftsMan.Description %>
            </div>
        </div>
    <div class="btn-group btn-group-lg" role="group" aria-label="Basic example">
        <a class="btn btn-outline-success" href="CraftsManConnection.aspx?id=<%= craftsMan.Id %>" role="button">Выбрать</a>
        <a class="btn btn-outline-danger" href="CraftsManPage.aspx" role="button">Другие варианты</a>
    </div>
</asp:Content>
