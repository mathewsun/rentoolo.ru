<%@ Page Title="Токены" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tokens.aspx.cs" Inherits="Rentoolo.Tokens" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <script>
        $(document).ready(function () {

            $('#tokensCountBuy').bind('input', function () {

                var balanceText = $('#balanceValue').text();

                var correctBalanceText = balanceText.replace(/\s/g, '');

                var balance = parseFloat(correctBalanceText);

                var oneTokenCost = parseFloat($('#oneTokenCost').text());

                var data = $(this).val();

                if (!isNaN(parseInt(data, 10))) {
                    $(this).removeClass("bg-danger");

                    var fullSum = oneTokenCost * data;

                    $('#fullCost').text(fullSum.toFixed(2));

                    if (fullSum > balance) {
                        $(this).prop('title', 'Недостаточно средств');
                        $(this).addClass("bg-danger");
                    }
                    else {
                        $(this).prop('title', '');
                        $(this).removeClass("bg-danger");
                    }

                }
                else {
                    $(this).addClass("bg-danger");

                }

            });

            $('#tokensCountSell').bind('input', function () {

                var tokensCountText = $('#tokensCountHave').text();

                var correctTokensCountText = tokensCountText.replace(/\s/g, '');

                var tokensCount = parseFloat(correctTokensCountText);

                var oneTokenCost = parseFloat($('#oneTokenCost').text());

                var data = $(this).val();

                if (!isNaN(parseInt(data, 10))) {
                    $(this).removeClass("bg-danger");

                    var fullSum = oneTokenCost * data;

                    $('#fullCostSell').text(fullSum.toFixed(2));

                    if (data > tokensCount) {
                        $(this).prop('title', 'Недостаточно токенов');
                        $(this).addClass("bg-danger");
                    }
                    else {
                        $(this).prop('title', '');
                        $(this).removeClass("bg-danger");
                    }

                }
                else {
                    $(this).addClass("bg-danger");

                }

            });


        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card d-md-block d-lg-block mb-4">
        <div class="card-body">
            <h6 class="mb-3">Всего токенов: <span id="fullTokensCount">10 000 000 000</span></h6>
            <h6 class="mb-3">Токенов, доступных к покупке: <span id="availableTokensCount">4 900 000 000</span></h6>
            <h6 class="mb-3">Стоимость токена сегодня: <span id="oneTokenCost"><%=OneTokenTodayCost.ToString("N2").Replace(",",".") %></span> р.</h6>
            <h6 class="mb-3">Доход Rentoolo сегодня: <span id="rentooloTodayProfit">0</span> р.</h6>
            <h6 class="mb-3">Доход одного токена сегодня: <span id="oneTokenTodayProfit">0</span> р.</h6>
            <div>
                На продажу выставлено 49% токенов. 
                <br />
                Список покупок и продаж в открытом доступе. 
                <br />
                Каждый токен приносит доход в равной доли от общего количества токенов.
                <br />
                Купить и продать токены можно в любой момент.
                <br />
                Rentoolo обеспечивает <span class="rentooloYearPercents">15</span>% годовых с ежесуточным ростом стоимости токенов до тех пор, пока не будут проданы 49%, далее стоимость зависит от рыночной востребованности.
            </div>
            <br />
            <br />
            <div style="display: -webkit-box;">
                <asp:TextBox ID="tokensCountBuy" ClientIDMode="Static" CssClass="form-control placeholder-right" Width="80px" runat="server">1000</asp:TextBox>
                <div class="fullCostLable padding-left-10">
                    Стоимость: 
                </div>
                <div>
                    <span id="fullCost">100</span> р.
                </div>
                <div class="input-group-btn" style="padding-left: 20px;">
                    <asp:Button ID="ButtonBuyTokens" runat="server" CssClass="btn btn-primary" Text="Купить" OnClick="ButtonBuyTokens_Click" />
                </div>
            </div>

            <%if (User != null)
                { %>
            <br />
            <br />

            <h6 class="mb-3">Ваш баланс: <span id="balanceValue"><%if (UserWalletRURT != null)
                                                                     { %><%=UserWalletRURT.Value.ToString("N2").Replace(",",".") %><%} %></span> р.</h6>
            <h6 class="mb-3">У вас токенов: <span id="tokensCountHave"><%if (UserWalletRENT != null)
                                                                           { %><%=UserWalletRENT.Value.ToString("N0") %><%} %></span></h6>
            <div style="display: -webkit-box;">
                <asp:TextBox ID="tokensCountSell" ClientIDMode="Static" CssClass="form-control placeholder-right" Width="80px" runat="server">0</asp:TextBox>
                <div class="fullCostSellLabel padding-left-10">
                    Цена продажи: 
                </div>
                <div>
                    <span id="fullCostSell">0</span> р.
                </div>
                <div class="input-group-btn" style="padding-left: 20px;">
                    <asp:Button ID="ButtonSellTokens" runat="server" CssClass="btn btn-primary" Text="Продать" OnClick="ButtonSellTokens_Click" />
                </div>
            </div>

            <%} %>
        </div>
    </div>
</asp:Content>
