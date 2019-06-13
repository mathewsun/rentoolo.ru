<%@ Page Title="Избранное" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Favorites.aspx.cs" Inherits="Rentoolo.Favorites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <ul class="list-group media-list media-list-stream mb-4">

        <li class="media list-group-item p-4">

            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted">28 объявлений</small>
                    <h6>Избранное:</h6>
                </div>

                <div class="media-body-inline-grid" data-grid="images">
                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/unsplash_1.jpg">
                        <div class="item-wrap__wrap ">
                            <div class="item-wrap__name"><a href="#">Холодильник Indesit 90l / 40l </a></div>
                            <div class="item-wrap__cost">11 000 ₽</div>
                            <div class="item-wrap__description">
                                <p>Бытовая техника</p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 14:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>

                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/instagram_1.jpg">
                        <div class="item-wrap__wrap">
                            <div class="item-wrap__name"><a href="#">Кофемашина Tefal l400</a></div>
                            <div class="item-wrap__cost">13 000 ₽</div>
                            <div class="item-wrap__description">
                                <p>Техника для кухни</p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 12:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>

                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/instagram_11.jpg">
                        <div class="item-wrap__wrap">
                            <div class="item-wrap__name"><a href="#">Наушники проводные</a></div>
                            <div class="item-wrap__cost">2 000 ₽</div>
                            <div class="item-wrap__description">
                                <p></p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 11:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>

                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/unsplash_2.jpg">
                        <div class="item-wrap__wrap">
                            <div class="item-wrap__name"><a href="#">Копьютер в сборке intel core i7, nvidia 2080rtx, 1tb hdd, 128gb ssd, 16gb</a></div>
                            <div class="item-wrap__cost">41 000 ₽</div>
                            <div class="item-wrap__description">
                                <p>Компьютеры</p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 10:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>
                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/instagram_2.jpg">
                        <div class="item-wrap__wrap">
                            <div class="item-wrap__name"><a href="#">Ноутбук Acer Predator Heliios-300</a></div>
                            <div class="item-wrap__cost">61 000 ₽</div>
                            <div class="item-wrap__description">
                                <p>Компьютеры</p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 9:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>

                    <div class="list-item-wrap" style="display: none">
                        <img class="list-item-wrap-img" src="assets/img/instagram_4.jpg">
                        <div class="item-wrap__wrap">
                            <div class="item-wrap__name"><a href="#">Колонка bluetooth v4.3 18w</a></div>
                            <div class="item-wrap__cost">4 000 ₽</div>
                            <div class="item-wrap__description">
                                <p></p>
                                <p>р-н Торговая сторона</p>
                                <div class="item-wrap__data">Вчера 14:15</div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Добавить в Избранное"></div>
                    </div>
                </div>
            </div>
        </li>


    </ul>

</asp:Content>
