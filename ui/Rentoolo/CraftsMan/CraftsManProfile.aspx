<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManProfile.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManProfile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        <div class="row">
            <div class="col">
                <img class="container-fluid" src="../img/kitchen/avatars/94671454_277769756585463_6526749104637214720_n.jpg" />

            </div>
            <div class="col order-12">
                <h1 class="name">Alan Doe</h1>
                <h3 class="tagline">Full Stack Developer</h3>
            </div>
        </div>
    </div>
    <div class="container blue-color">
        <div class="col">
            <div class="container">
                <h1 class="display-4">Немного о себе</h1>
                <p class="lead">Следует отметить, что строго утвержденного шаблона резюме нет, но следующая информация должна быть в нем отражена обязательно: ФИО, контакты соискателя, опыт работы, основные достижения, сведения об образовании, как основном, так и дополнительном, профессиональные навыки. Остальное – Ваша фантазия и творческий подход. Основное внимание уделите Вашим функциональным обязанностям и достижениям в работе – данной информации работодатель уделяет больше всего внимания.</p>
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
            <h1 class="display-4">Немного о себе</h1>
            <p class="lead">Немного о себе.</p>
        </div>
    </div>

</asp:Content>
