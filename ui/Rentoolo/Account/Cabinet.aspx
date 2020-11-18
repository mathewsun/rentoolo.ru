<%@ Page Title="Личный кабинет" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cabinet.aspx.cs" Inherits="Rentoolo.Account.Cabinet" %>

<%@ Import Namespace="Rentoolo.Model" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-logo">
            <h4><%: Title %></h4>
        </div>
        <div class="additem-category">
            <div class="additem-right additem__way" cid="1001">


            <br />

            <div>
                <input type="file" id="f" />
            </div>

            <script type="text/javascript">

                window.onload = function () {

                    let finput = document.getElementById('f');
                    finput.onchange = function (e) {
                        let imgHeight = 0, imgWidth = 0;
                        let f = e.target.files[0];

                        let img = new Image();

                        let reader = new FileReader();

                        img.onload = function (e) {
                            console.log(e);
                            console.log("is img");
                            imgHeight = this.width;
                            imgWidth = this.height;

                            console.log(imgHeight);
                            console.log(imgWidth);

                            reader.readAsArrayBuffer(f);

                        }

                        img.src = URL.createObjectURL(f);



                        console.log(e.target.files[0]);



                        reader.onloadend = function (e) {



                            let buf = reader.result;
                            console.log(buf);
                            let uintbuf = new Uint8Array(buf);
                            //console.log(uintbuf);



                            sendFile(uintbuf, imgHeight, imgWidth);
                        }



                    }

                }

                function sendFile(buffer, height, width) {



                    let url = "/api/Avatars";

                    //console.log(buffer.toString());

                    let data = {
                        Buffer: buffer.toString(),
                        FileName: "some.jpg",
                        UserId: "4BB6FE84-B80E-4B7A-A62E-1D2CB44A014E",
                        Height: height,
                        Width: width
                    };

                    fetch(url, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(data)
                    }).then((data) => {
                        console.log(data);
                    });


                }








            </script>














                <table class="marginTable cabinetTable">
                    <tr>
                        <td>Логин:
                        </td>
                        <td><%=User.UserName %></td>
                    </tr>
                    <tr>
                        <td>Баланс: &nbsp; 
                        </td>
                        <td><%if (UserWalletRURT != null)
                                { %><%=UserWalletRURT.Value.ToString("N2") %><%}
                                                                                 else
                                                                                 {%>0<%} %>р. <a href="/Account/CashIn" title="Пополнить">Пополнить</a>
                        </td>
                    </tr>
                </table>
                <div style="padding-top: 15px;">
                    <a href="MyAdverts.aspx" class="button-changePassword settingButton">Мои объявления</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="MyAdverts.aspx" class="button-changePassword settingButton">Вы смотрели</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="Settings.aspx" class="button-changePassword settingButton">Настройки</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="Manage.aspx" class="button-changePassword settingButton">Сменить пароль</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="LoginStatistics.aspx" class="button-changePassword settingButton">Статистика входов</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/CashOut.aspx" class="button-changePassword settingButton">Вывод средств</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Tokens.aspx" class="button-changePassword settingButton">Токены</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/TokensBuying.aspx" class="button-changePassword settingButton">История покупок токенов</a>
                </div>
                <div style="padding-top: 15px;">
                    <a href="/Account/TokensSelling.aspx" class="button-changePassword settingButton">История продаж токенов</a>
                </div>
                <% if (Page.User.IsInRole("Administrator"))
                    { %>
                <div style="padding-top: 15px;">
                    <a href="/Admin/Admin.aspx" class="button-changePassword settingButton">Управление</a>
                </div>
                <% } %>
                <div style="padding-top: 15px;">
                    Реферальная ссылка:
                    <br />
                    <input id="refferalLink" class="refferalLink" onclick="copyToClipboardUrl()" type="text" title="Скопировать" value="<%=Helper.GetRefferalLink(Request, this.User.PublicId) %>" />
                </div>
                <hr />
                <div style="padding-top: 15px;">
                    <a href="/Account/DeviceSettings.aspx" class="button-changePassword settingButton">Device Settings</a>
                </div>

                <div>
                    Текущая ссылка на профиль:



                    Уникальная ссылка на профиль пользователя ( <%= User.UniqueUserName %> ):
                    <input type="text" name="uniqueName" />

                    <asp:Button ID="ButtonSetUniqName" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Set name" OnClick="ButtonSetUniqName_Click" />


                    <br />

                    Выбранный город:<%-- <%=// User.SelectedCity %>--%>
                    <input name="selectedCity" type="text" list="cities" />

                    <datalist id="cities">
                        <% foreach (var city in AllCities)
                            { %>

                        <option>
                            <%=city %>
                        </option>

                        <%} %>
                    </datalist>

                    <asp:Button ID="ButtonCity" runat="server" Text="выбрать город" OnClick="ButtonCity_Click" />



                </div>


                <div>
                    Дата рождения: <%= User.BirthDay %>
                    <input name="birthDay" type="date" />
                    <asp:Button ID="ButtonBirthDay" runat="server" Text="установить другую дату рождения" OnClick="ButtonBirthDay_Click" />




                </div>

            </div>
        </div>
    </div>

    <script type="text/javascript">

        function copyToClipboardUrl() {
            var copyText = document.getElementById("refferalLink");
            copyText.select();
            document.execCommand("copy");
        }

        function copyToClipboardAccountId() {
            var copyText = document.getElementById("accountId");
            copyText.select();
            document.execCommand("copy");
        }
    </script>
</asp:Content>
