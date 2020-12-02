<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManProfile.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col">
                <img class="container-fluid" src="../img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg" />
                <img class="container-fluid" src="<%=craftsMan.ImgUrls %>" />
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
