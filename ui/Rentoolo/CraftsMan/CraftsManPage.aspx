<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CraftsManPage.aspx.cs" Inherits="Rentoolo.CraftsMan.CraftsManPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">

    <link href='assets/css.css?family=Open+Sans:400,300,600' rel='stylesheet' type='text/css'>
    <link href="content/toolkit.css" rel="stylesheet">
    
    <link href="content/application.css" rel="stylesheet">
    <style>
        @media (min-width: 576px) {
            .card-columns {
                column-count: 2;
            }
        }

        @media (min-width: 768px) {
            .card-columns {
                column-count: 3;
            }
        }

        @media (min-width: 992px) {
            .card-columns {
                column-count: 4;
            }
        }

        @media (min-width: 1200px) {
            .card-columns {
                column-count: 5;
            }
        }
    </style>

</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">



    <li class="media list-group-item p-4">

        <div class="search-input-group">

            <div class="search-input-group__main-input">
                <input style="width: 100%" type="text" id="Text1" class="form-control" runat="server" placeholder="Поиск по анкетам специалистов" />
                <asp:Button ID="Button1" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Найти" OnClick="ButtonSearch_Click" />
            </div>
            <div class="main-find__checkbox-label">
                <input type="checkbox" name="onlyInName" />
                <span>Только в названии</span>
            </div>

            <div class="main-find_price">
                <span>Стоимость услуг:</span>
                <input type="number" name="startPrice" placeholder="От" />
                <input type="number" name="endPrice" placeholder="До" />
            </div>


            <%--<div class="main-find_date">
                 <span>Дата размещения:</span> 
                 <input type="date" id="StartDate" placeholder="От">
                 <input type="date" id="EndDate" placeholder="До">
                                    </div>
         51a73fc4667aa3e6c7e3a45ccc1c5b82545a2ee0 --%>


            <div class="city-sortby__wrap">
                <div>
                    <span style="float: left;">Город:</span>&nbsp;
                                        <input type="text" name="city" list="cities" />
                    <br />
                    <datalist id="cities">

                        <% foreach (var city in AllCities)
                            { %>

                        <option>
                            <%=city %>
                        </option>

                        <%} %>
                    </datalist>
                </div>
                <%-- citys end--%>

                <div class="sortby">
                    <select name="sortBy" id="sortBy">
                        <option value="date">По дате</option>
                        <option value="price">По стоимости услуг</option>
                        <option value="radius">По удаленности</option>
                    </select>
                </div>
                <%-- sortby end--%>
            </div>
            <%-- city-sortby__wrap end--%>
        </div>
        <%-- end search-input-group--%>

        <%--            <div class="input-group">
                                <div class="rowed-grid">
                                    <div class="searchbar-grid">
                                        <div style="width: 100%">
                                            <input style="width: 100%" type="text" id="InputSearch" class="form-control" runat="server" placeholder="Поиск по объявлениям" />
                                        </div>
                                        <div class="input-group-btn">
                                            <asp:Button ID="ButtonSearch" runat="server" CssClass="btn btn-secondary align-self-stretch" Text="Найти" OnClick="ButtonSearch_Click" />
                                        </div>
                                    </div>
                                    <div class="main-find__checkbox-label">
                                        <input type="checkbox" name="onlyInName" />
                                        <span>Только в названии</span>
                                    </div>
                                    <div>
                                        &nbsp;
                                        <br />
                                    </div>

                                
                                 </div> 
                            </div> --%>

    </li>
    <h4 class="mb-4">Специалисты</h4>
    <div class="card-columns">
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">1 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">2 Card title</h4>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">3 Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">4 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">5 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">6 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">7 Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">8 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <h4 class="card-title">9. Card title</h4>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
        <div class="card">
            <div class="card-body">
                <img class="card-img-top" src="../assets/img/instagram_10.jpg" alt="Card image">
                <h4 class="card-title">10 Card title</h4>
                <p class="card-text">Card Text..</p>
            </div>
        </div>
    </div>

    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/chart.js"></script>
    <script src="js/toolkit.js"></script>
    <script src="js/application.js"></script>
    <script>
      // execute/clear BS loaders for docs
      $(function(){while(window.BS&&window.BS.loader&&window.BS.loader.length){(window.BS.loader.pop())()}})
    </script>

</asp:Content>
