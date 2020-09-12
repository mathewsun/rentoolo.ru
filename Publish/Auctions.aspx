<%@ Page Title="Аукционы" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Auctions.aspx.cs" Inherits="Rentoolo.Auctions" %>
<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        $(document).ready(function () {
            $(".item-wrap__like").click(function () {
                addF($(this).parent().attr("aid"));
            });
        });

        function addF(aId) {
            $.get("/Events.ashx?e=afa&id=" + aId);
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
         <h4>Все аукционы</h4>

    <ul class="list-group media-list media-list-stream mb-4">

        <li class="media list-group-item p-4">

            <div class="media-body">
                <div class="media-heading">
                    <small class="float-right text-muted">28 объявлений</small>
                    <h6>Аукционы:</h6>
                </div>
                <div class="media-body-inline-grid">
                    <%foreach (var item in ListItems)
                        { %>
                    <div class="list-item-wrap" style="display: none" aid="<%=item.Id%>">
                        <img class="list-item-wrap-img" src="assets/img/unsplash_1.jpg">
                        <div class="item-wrap-content">
                            <div class="item-wrap-name"><a href="#"><%=item.Name%></a></div>
                            <div class="item-wrap-cost"><%=item.StartPrice%> ₽<%--<%=item.CurrencyAcronim%>--%></div>
                            <div class="item-wrap__description">
                                <p>ID аукциона: <%=item.Id%></p>
                                <%--<p>Имя владельца аукциона: <%=item.Name%> рублей</p>--%>
                                <p>Стартовая цена аукциона: <%=item.StartPrice%></p>
                                <p>Дата и время создания аукциона: <%=item.Created %></p>
                                <p>Текущий пользователь: <%--=item.UserName --%></p>  <!--Нужно разобраться -->
                                <div class="item-wrap__data"><%=item.Created.ToString("dd.MM.yyyy HH:mm")%></div>
                            </div>
                        </div>
                        <div class="item-wrap__like" title="Удалить из Избранного"></div>
                    </div>
                    <%} %>

                </div>
            </div>
        </li>


    </ul>
</asp:Content>
