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
                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/unsplash_1.jpg">
                    </div>

                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_1.jpg">
                    </div>

                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_13.jpg">
                    </div>

                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/unsplash_2.jpg">
                    </div>
                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_1.jpg">
                    </div>

                    <div style="display: none">
                        <img data-action="zoom" data-width="500" data-height="500" src="assets/img/instagram_13.jpg">
                    </div>
                </div>

                <ul class="media-list mb-2">
                    <li class="media mb-3">
                        <img
                            class="media-object d-flex align-self-start mr-3"
                            src="assets/img/avatar-fat.jpg">
                        <div class="media-body">
                            <strong>Майк Браун: </strong>
                            Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec ullamcorper nulla non metus auctor fringilla. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis.
               
                        </div>
                    </li>
                    <li class="media">
                        <img
                            class="media-object d-flex align-self-start mr-3"
                            src="assets/img/avatar-mdo.png">
                        <div class="media-body">
                            <strong>Виктория Золотова: </strong>
                            Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.
               
                        </div>
                    </li>
                </ul>
            </div>
        </li>

        <li class="media list-group-item p-4">
            <img
                class="media-object d-flex align-self-start mr-3"
                src="assets/img/avatar-fat.jpg">
            <div class="media-body">
                <div class="media-body-text">
                    <div class="media-heading">
                        <small class="float-right text-muted">12 min</small>
                        <h6>Майк Браун</h6>
                    </div>
                    <p>
                        Donec id elit non mi porta gravida at eget metus. Integer posuere erat a ante venenatis dapibus posuere velit aliquet. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Morbi leo risus, porta ac consectetur ac, vestibulum at eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit.
             
                    </p>
                </div>
            </div>
        </li>

        <li class="media list-group-item p-4">
            <img
                class="media-object d-flex align-self-start mr-3"
                src="assets/img/avatar-mdo.png">
            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted">78 объявлений</small>
                    <h6>Недвижимость:</h6>
                </div>

                <p>
                    Donec ullamcorper nulla non metus auctor fringilla. Vestibulum id ligula porta felis euismod semper. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui.
           
                </p>

                <div class="media-body-inline-grid" data-grid="images">
                    <img style="display: none" data-width="640" data-height="640" data-action="zoom" src="assets/img/instagram_3.jpg">
                </div>

                <ul class="media-list">
                    <li class="media">
                        <img
                            class="media-object d-flex align-self-start mr-3"
                            src="assets/img/avatar-dhg.png">
                        <div class="media-body">
                            <strong>Dave Gamache: </strong>
                            Donec id elit non mi porta gravida at eget metus. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Donec ullamcorper nulla non metus auctor fringilla. Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Sed posuere consectetur est at lobortis.
               
                        </div>
                    </li>
                </ul>
            </div>
        </li>
    </ul>

</asp:Content>
