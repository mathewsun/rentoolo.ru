<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManTaskDetails.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManTaskDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
           <%-- <div class="col">
                <img class="container-fluid" src="../img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg" />
                <img class="container-fluid" src="<%=order.ImgUrls %>" />
            </div>--%>
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
    <div id="carousel" class="carousel slide" data-ride="carousel">
        <ol class="carousel-indicators">
            <li data-target="#carouselExampleIndicators" data-slide-to="0" class="active"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="1"></li>
            <li data-target="#carouselExampleIndicators" data-slide-to="2"></li>
        </ol>
        <div class="carousel-inner">
            <div class="carousel-item active">
                <img class="d-block w-100" src="../img/kitchen/falafel-s-ovoshami.jpg">
            </div>
            <div class="carousel-item">
                <img class="d-block w-100" src="../img/kitchen/govadina-v-fruktovom-marinade.jpg" alt="Второй слайд">
            </div>
            <div class="carousel-item">
                <img class="d-block w-100" src="../img/kitchen/falafel-s-ovoshami.jpg" alt="Третий слайд">
            </div>
        </div>
        <a class="carousel-control-prev" href="#carousel" role="button" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="carousel-control-next" href="#carousel" role="button" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
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

</asp:Content>
