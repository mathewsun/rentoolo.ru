<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Advert.aspx.cs" Inherits="Rentoolo.Advert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="assets/css/jQuery.Brazzers-Carousel.css" rel="stylesheet">
    <script src="/assets/js/jQuery.Brazzers-Carousel.js"></script>
    <script src="/assets/js/jsonUtils.js?2"></script>
    <script src="https://cdn.jsdelivr.net/npm/vue@2/dist/vue.js"></script>

    <style>
        div.button {
          display:inline-block;
          -webkit-appearance:button;
          padding:3px 8px 3px 8px;
          font-size:13px;
          position:relative;
          cursor:context-menu;
          box-shadow: 0 0 5px -1px rgba(0,0,0,0.2);
          border:1px solid #CCC;
          background:#DDD;
        }

        div.button:active {
            color:red;
            box-shadow: 0 0 5px -1px rgba(0,0,0,0.6);
        }


        .like{
            width: 40px;
            height: 40px;
        }

        .dislike{
            width: 40px;
            height: 40px;
            transform: rotate(180deg);
        }



    </style>

    <script>
        $(document).ready(function () {
            $.get("/assets/json/categories.json", function (data) {
                var category = findJsonElementById(data, <%=AdvertItem.Category%>);
        
                if (category !== undefined) {
                    $("#category").html(category.name_ru);
                }
            });

            $(".photoContainer").each(function (index) {
                var htmlString = '';
                var imgUrls = $(this).attr("data");
                JSON.parse(imgUrls,
                    function (k, v) {
                        if (k != "") {
                            htmlString += "<img src='" + v + "' style='height: 600px; width: 700px;' alt='' />";
                        }
                    });

                $(this).html(htmlString);
            });

            $(".photoContainer").brazzersCarousel();
        });

        
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="advert">
        <div class="media-body-inline-grid" data-grid="images">
            <div class="photoContainer" data='<%=AdvertItem.ImgUrls%>'></div>
        </div>
        <div class="additem-category">
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span>Категория</span>
            </div>
            <div class="additem-right additem__way" cid="1001">
                <a href="#" id="category">Category</a>
                <input type="hidden" id="category_hidden" value="1001" runat="server" />
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Название объявления</span>
            </div>
            <div class="additem-right">
                <%=AdvertItem.Name %>
            </div>
        </div>

        <div class="additem-category additem-text__wrap">
            <div class="additem-left">
                <span class="additem-title">Описание объявления</span>
            </div>
            <div class="additem-right advert-description">
                <%=AdvertItem.Description %>
            </div>
        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Цена</span>
            </div>
            <div class="additem-right">
                <%=AdvertItem.Price %>
                <span class="price__value">₽</span>
            </div>

        </div>

        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Видео с Youtube</span>
            </div>
            <div class="additem-right additem__video">
                <%=AdvertItem.YouTubeUrl %>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left additem-contact">
                Контактная информация
            </div>

        </div>


        <div class="additem-category">
            <div class="additem-left additem-contact">
                <a href="Account/UserProfile.aspx?id=<%=AdvertItem.CreatedUserId %>" >
                    <%= AnotherUser.UserName %>
                </a>
            </div>

        </div>


        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Место сделки</span>
            </div>
            <div class="additem-right additem-place">
                <%=AdvertItem.Address %>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left ">
            </div>
            <div class="additem-right additem-map">
                <div class="additem-map">
                    <div id="map"></div>
                    <script>
                        // Initialize and add the map
                        function initMap() {
                            // The location of Uluru
                            var uluru = { lat: 55.751244, lng: 37.618423 };
                            // The map, centered at Uluru
                            var map = new google.maps.Map(
                                document.getElementById('map'), { zoom: 16, center: uluru });
                            // The marker, positioned at Uluru
                            var marker = new google.maps.Marker({ position: uluru, map: map });
                        }
                    </script>
                    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAEM6pBamtfcOxQiIHbO9HY76xvNiUxgIo&callback=initMap" async defer></script>
                </div>
            </div>
        </div>
        <div class="additem-category">
            <div class="additem-left">
                <span class="additem-title">Телефон</span>
            </div>
            <div class="additem-right additem-phone">
                <%=AdvertItem.Phone %>
            </div>
        </div>
        <div>

            <h5>
                <a href="CreateComplaint.aspx?complaintObjectType=1&userRecivier=<%=AdvertItem.CreatedUserId %>&objectId=<%=AdvertItem.Id %>">
                    Пожаловаться
                </a>
            </h5>

        </div>
        <div>
            <div id="vue-ld-app">
                {{message}}
                    <table>
                        <tr>
                            <td>
                                <div class="button" @click="likeItem" >
                                    <img src="assets/img/notLiked.jpg" class="like" /> 
                                </div>
                        
                            </td>
                            <td>
                                <%= ItemLikes %>
                            </td>
                            <td>
                                <div class="button" @click="disLikeItem"  >
                                    <img src="assets/img/Liked.png" class="dislike"  /> 
                                </div>
                        
                            </td>
                            <td>
                                <%= ItemDislikes %>
                            </td>
                        </tr>
                    </table>
            </div>
            <script type="text/javascript">

                let itemldApp = new Vue({
                    el: '#vue-ld-app',
                    data: {
                        message: 'Привет, Vue!',
                        comments: []
                    },
                    methods: {
                        likeItem() {



                            let url = 'api/itemLikesDislikes';

                            let jsonData = {
                                Type: "like",
                                UserId: "<%=User.UserId %>",
                                ObjectType: 0,
                                ObjectId: <%= AdvertItem.Id %>
                            }

                            let data =
                            {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(jsonData)
                            }

                            

                            //console.log

                            fetch(url, data)
                                .then((response) => {
                                    return response.json();
                                })
                                .then((data) => {
                                    console.log(data);
                                    this.comments = data;
                                });

                        },
                        disLikeItem() {

                            let url = 'api/itemLikesDislikes';


                            let jsonData = {
                                Type: "dislike",
                                UserId: "<%=User.UserId %>",
                                ObjectType: 0,
                                ObjectId: <%= AdvertItem.Id %>
                            }


                            let data =
                            {
                                method: 'POST',
                                headers: {
                                    'Content-Type': 'application/json'
                                },
                                body: JSON.stringify(jsonData)
                            }

                            fetch(url, data)
                                .then((response) => {
                                    return response.json();
                                })
                                .then((data) => {
                                    console.log(data);
                                    this.comments = data;
                                });

                        }
                    }
                    
                })


            </script>

        </div>
        <div>
            <div>
                <h3>
                    Добавить комментарий:
                </h3>
                <div>
                    Комментарий: <asp:TextBox ID="TextBoxComment" runat="server"></asp:TextBox>
                    <asp:Button ID="Button1" runat="server" Text="создать комментарий" OnClick="Button1_Click" />

                </div>
            </div>
            <div>
                <h4>
                    Комментарии:
                </h4>
                
                <div id="vue-app">
                    {{message}}
                    <div v-for="(comment, index) in comments" v-bind:key="index">
                        <div>
                        Name:  {{comment.UserName}}   <br />
                        Created: {{comment.Date}}          <br />
                        Comment: {{comment.Comment}}         <br />
                        Likes: {{comment.LikesCount}}             <br />
                        Dislikes: {{comment.DisLikesCount}}        <br />
                        HaveLiked: {{comment.HaveLiked}}  <br />
                        HaveDisLiked:  {{comment.HaveDisLiked}}  <br />
                            </div>
                        <div class="button" @click="Like(comment.Id)">Like</div>
                        <div class="button" @click="DisLike(comment.Id)">DisLike</div>
                    </div>
                </div>

                <script type="text/javascript">


                    let app = new Vue({
                        el: '#vue-app',
                        data: {
                            message: 'Привет, Vue!',
                            comments: []
                        },
                        created: function () {

                            let url = 'api/Comments/<%=AdvertItem.Id %>';

                            let data = {}

                            fetch(url,data)
                                .then((response) => {
                                    return response.json();
                                })
                                .then((data) => {
                                    console.log(data);
                                    this.comments = data;
                                });


                        },
                        methods: {
                            Like(commentId) {
                                console.log('LIKE!');
                                this.LDRequest("Like", commentId);
                            },
                            DisLike(commentId) {
                                console.log('DisLike!');
                                this.LDRequest("DisLike", commentId);
                            },
                            LDRequest(cmd,commentId) {

                                let url = 'api/LikesDislikes';

                                let jsonData = { Cmd: cmd, CommentId: commentId };
                                let data = {
                                    method: 'PUT',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    body: JSON.stringify(jsonData)
                                }

                                fetch(url, data)
                                    .then((response) => {
                                        return response.json();
                                    })
                                    .then((data) => {
                                        console.log(data);

                                    });


                            }
                        }
                    })

                </script>


            </div>
        </div>

    </div>
</asp:Content>
