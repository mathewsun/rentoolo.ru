<%@ Page Title="Токены" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tokens.aspx.cs" Inherits="Rentoolo.Tokens" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    

    <script>
        $(document).ready(function () {

            var availableTokensCount = $('#availableTokensCount').text();

            $("#availableTokensCount").text(numberWithSpaces(availableTokensCount));

            var sellTokensCount = $('#sellTokensCount').text();

            $("#sellTokensCount").text(numberWithSpaces(sellTokensCount));

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

            

            window.setInterval(timer, 1000);
        });

        //$("#oneTokenCost").on('change',function(){
                
        //    var oneTokenCost = parseFloat($('#oneTokenCost').text());

            

        //    $("#oneTokenCost").html("<span class='tokenCostFirstPart'></span><span class='tokenCostSecondPart'></span>");

        //});

        function timer() {

            var h, m, s;

            var d = new Date();

            h = <%= DateTime.Now.Hour %>;
            m = d.getMinutes();
            s = d.getSeconds();

            var secondsCount = h*3600 + m*60 + s;

            var minutesCount = h*60 + m;

            var hoursCount = h;

            var value = $('#oneTokenCostHidden').val();

            var percentsPow = Math.pow(1.00002897611, hoursCount);

            var currentHourValue = value * percentsPow;

            var hoursCountPlus = hoursCount + 1;

            var percentsPowPlusHour = Math.pow(1.00002897611, hoursCountPlus);

            var plusHourValue = value * percentsPowPlusHour;

            var diffValuePlusHour = plusHourValue - currentHourValue;

            var secondValue = diffValuePlusHour / 3600;

            var secondsCount = m*60 + s;

            var diffValue = secondsCount * secondValue;

            var currentValue = currentHourValue + diffValue;

            var firstPart = currentValue.toString().substr(0, currentValue.toString().indexOf('.') + 3); 

            var secondPart = currentValue.toString().substr(currentValue.toString().indexOf('.') + 3, currentValue.length); 

            $('#oneTokenCost').html("<span class='tokenCostFirstPart'>" + firstPart.toString() + "</span><span class='tokenCostSecondPart'>" + secondPart + "</span>");

            var ttt = 0;
        }

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card d-md-block d-lg-block mb-4">
        <div class="card-body">
            <h6 class="mb-3">Цена токена: <a href="/TokensCost" title="График стоимости"><span id="oneTokenCost"><%=OneTokenTodayCost.ToString().Replace(",",".") %></span> р.</a></h6>
            <input type="hidden" id="oneTokenCostHidden" value="<%=OneTokenTodayCost.ToString().Replace(",",".") %>" />
            <h6 class="mb-3">Всего токенов: <span id="fullTokensCount">10 000 000 000</span></h6>
            <h6 class="mb-3">Доступно токенов: <span id="availableTokensCount"><%=AvailableTokensCount%></span></h6>
            <h6 class="mb-3">Продано токенов: <span id="sellTokensCount"><%=SellTokensCount%></span></h6>
            <h6 class="mb-3" style="color: grey;">Доход Rentoolo сегодня: <span id="rentooloTodayProfit">0</span> р.</h6>
            <h6 class="mb-3" style="color: grey;">Доход одного токена сегодня: <span id="oneTokenTodayProfit">0</span> р.</h6>
            <h6 class="mb-3" style="color: grey;">Ваш доход сегодня: <span id="oneTokenTodayProfit">0</span> р.</h6>
            <div>
                На продажу выставлено 49% токенов. 
                <br />
                Список <a href="/TokensOperations"><span class="strong">всех операций</span></a>, <a href="/TokensBuying"><span class="strong">покупок</span></a> и <a href="/TokensSelling"><span class="strong">продаж</span></a> токенов в открытом доступе. 
                <br />
                Каждый токен приносит доход в равной доли от общего количества токенов.
                <br />
                Купить и продать токены можно в любой момент.
                <br />
                Rentoolo обеспечивает <span class="rentooloYearPercents">30</span>% годовых с постоянным ростом стоимости токенов. Как будут проданы 49% дальше цена будет зависеть от рынка и вырастет в кратном размере.
            </div>
            <br />
            <%if (User != null)
                { %>

            <h6 class="mb-3">Ваш баланс: <span id="balanceValue"><%if (UserWalletRURT != null)
                                                                     { %><%=UserWalletRURT.Value.ToString("N2").Replace(",",".") %><%} %></span> р. <a href="/Account/CashIn"><span class="strong">пополнить</span></a></h6>
            <%} %>
            <div style="display: -webkit-box;">
                <asp:TextBox ID="tokensCountBuy" ClientIDMode="Static" CssClass="form-control placeholder-right" Width="80px" runat="server">1000</asp:TextBox>
                <div class="fullCostLable padding-left-10">
                    Стоимость: 
                </div>
                <div>
                    <span id="fullCost"><%= (1000 * OneTokenTodayCost).ToString("N2") %></span> р.
                </div>
                <div class="input-group-btn" style="padding-left: 20px;">
                    <asp:Button ID="ButtonBuyTokens" runat="server" CssClass="btn btn-primary" Text="Купить" OnClick="ButtonBuyTokens_Click" />
                </div>
            </div>

            <%if (User != null)
                { %>
            <br />

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
