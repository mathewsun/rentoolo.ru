<%@ Page Title="Личный кабинет" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cabinet.aspx.cs" Inherits="Rentoolo.Account.Cabinet" %>

<%@ Import Namespace="Rentoolo.Model" %>


<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">


    <style>

        body {
	        padding: 0;
	        margin: 0;
	        display: flex;
	        justify-content: center;
	        align-items: center;
	        min-height: 100vh;
        }

        #upload-container {
	        display: flex;
	        justify-content: center;
	        align-items: center;
	        flex-direction: column;
	        width: 300px;
	        height: 300px;
	        outline: 2px dashed #5d5d5d;
	        outline-offset: -12px;
	        background-color: #e0f2f7;
	        font-family: 'Segoe UI';
	        color: #1f3c44;
        }

        #upload-container img {
	        width: 90%;
            height: 90%;
	        margin-bottom: -30px;
	        user-select: none;
        }

        #upload-container label {
	        font-weight: bold;
        }

        #upload-container label:hover {
	        cursor: pointer;
	        text-decoration: underline;
        }

        #upload-container div {
	        position: relative;
	        z-index: 10;
        }

        #upload-container input[type=file] {
	        width: 0.1px;
	        height: 0.1px;
	        opacity: 0;
	        position: absolute;
	        z-index: -10;
        }

        #upload-container label.focus {
	        outline: 1px solid #0078d7;
	        outline: -webkit-focus-ring-color auto 5px;
        }

        #upload-container.dragover {
	        background-color: #fafafa;
	        outline-offset: -17px;
        }

        #imgContainer{
            visibility: hidden;
        }

    </style>


</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="additem">
        <div class="additem-logo">
            <h4><%: Title %></h4>
        </div>
        <div class="additem-category">
            <div class="additem-right additem__way" cid="1001">


            <br />
                <%--<div>
                    <img title="загрузить аватарку"  width="200px" height="200px" src="/assets/img/avatars/<%=User.UserId %>.png" onerror="this.src = '/assets/img/addphoto.png'" />

                </div>--%>
                <div id="upload-container">
                    <img  id="upload-image" onerror="onErrorAvatarHandler(this)"    src="/assets/img/avatars/<%=User.UserId %>.png"/>
		            <div>
			            <input id="file-input" type="file" name="file">
                        <div id="imgContainer" >
                            <label style="padding-left: 16px;" for="file-input">Выберите файл</label>
			                
                        </div>
			            
		            </div>
                    
                </div>

                <%--<div id="upload-container">
                    <img id="upload-image" onload="onErrorAvatarHandler()"    src="https://habrastorage.org/webt/dr/qg/cs/drqgcsoh1mosho2swyk3kk_mtwi.png"/>
		            <div>
			            <input id="file-input" type="file" name="file">
                        <div id="imgContainer">
                            <label style="padding-left: 16px;" for="file-input">Выберите файл</label>
			                <span>или перетащите его сюда</span>
                        </div>
			            
		            </div>
                    
                </div>--%>
                
            <%--<div>
                <input type="file" id="f" />
            </div>--%>

            <script type="text/javascript">


                var imgContainer;


                function onErrorAvatarHandler(img) {

                    let uploadImg = 'https://habrastorage.org/webt/dr/qg/cs/drqgcsoh1mosho2swyk3kk_mtwi.png';




                    imgContainer = document.getElementById('imgContainer');
                    imgContainer.style.visibility = "inherit";
                    img.src = uploadImg;
                    console.log("error avatar load not");
                    
                }



                window.onload = function () {

                    imgContainer = document.getElementById('imgContainer');


                    let finput = document.getElementById('file-input');
                    finput.onchange = function (e) {

                        let f = e.target.files[0];

                        let img = new Image();

                        let reader = new FileReader();

                        img.onload = function (e) {
                            
                            reader.readAsArrayBuffer(f);
                        }

                        img.src = URL.createObjectURL(f);

                        reader.onloadend = function (e) {

                            let buf = reader.result;
                            let uintbuf = new Uint8Array(buf);

                            sendFile(uintbuf);
                        }

                    }

                }

                function sendFile(buffer) {

                    let url = "/api/Avatars";

                    let data = {
                        Buffer: buffer.toString(),
                        FileName: "some.jpg",
                        UserId: "<%=User.UserId %>"
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
