<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>订单管理页面</title>
</head>
<body>
<div class="hrms_dept_container">
    <!-- 导航栏-->
    <%@ include file="/WEB-INF/commom/head.jsp"%>


    <!-- 中间部分（左侧栏+表格内容） -->
    <div class="hrms_dept_body">
        <!-- 左侧栏 -->
        <%@ include file="/WEB-INF/commom/leftsidebar.jsp"%>

        <!-- 部门表格内容 -->
        <div class="dept_info col-sm-10">
            <div class="panel panel-success">
                <!-- 路径导航 -->
                <div class="panel-heading">
                    <ol class="breadcrumb">
                        <li><a href="#">订单管理</a></li>
                        <li class="active">订单信息</li>
                    </ol>
                </div>
                <!-- Table -->
                <table class="table table-bordered table-hover" id="dept_table">
                    <thead>
                        <th>订单编号</th>
                        <th>客房套餐名称</th>
                        <th>套餐价格</th>
                        <th>早餐类型</th>
                        <th>入住时间</th>
                        <th>离开时间</th>
                        <th>顾客姓名</th>
                        <th>顾客电话</th>
                        <th>预订间数</th>
                        <th>总价格</th>
                        <th>入住状态</th>
                    </thead>
                    <tbody>
                        <c:forEach items="${page.list}" var="order">
                            <tr>
                                <td>${order.roomOrderNum}</td>
                                <td>${order.roomPriceName}</td>
                                <td>${order.roomPrice}</td>
                                <td>${order.breakfastType}</td>
                                <td>${order.checkInTime}</td>
                                <td>${order.checkOutTime}</td>
                                <td>${order.customerName}</td>
                                <td>${order.customerPhone}</td>
                                <td>${order.roomCount}</td>
                                <td>${order.roomOrderDetailPrice}</td>
                                <td>${order.roomOrderState}</td>
                                <c:if test="${order.roomOrderState==0}"><td>未入住</td></c:if>
                                <c:if test="${order.roomOrderState==1}"><td>已入住</td></c:if>
                                <c:if test="${order.roomOrderState==2}"><td>已取消</td></c:if>
                                <td>
                                    <a href="get_upd_room_order_byid?roomOrderDetailNum=${order.roomOrderDetailNum}" role="button" class="btn btn-primary order_edit_btn">编辑</a>
                                    <a href="#" role="button" class="btn btn-danger order_delete_btn">删除</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="panel-body">
                    <div class="table_items">
                        当前第<span class="badge">${page.pageNumber}</span>页，共有<span class="badge">${page.total}</span>页，总记录数<span class="badge">${page.totalNumber}</span>条。
                    </div>
                    <nav aria-label="Page navigation" class="pull-right">
                        <ul class="pagination">
                            <li><a href="get_room_order_page?pageNumber=1">首页</a></li>
                            <c:if test="${page.pageNumber==1}">
                                <li class="disabled">
                                    <a href="#" aria-label="Previous" class="prePage">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${page.pageNumber!=1}">
                                <li>
                                    <a href="#" aria-label="Previous" class="prePage">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${page.total<5?page.total:5}" step="1" var="itemPage">
                                <c:if test="${page.pageNumber == itemPage}">
                                    <li class="active"><a href="get_room_order_page?pageNumber=${itemPage}">${itemPage}</a></li>
                                </c:if>
                                <c:if test="${page.pageNumber != itemPage}">
                                    <li><a href="get_room_order_page?pageNumber=${itemPage}">${itemPage}</a></li>
                                </c:if>
                            </c:forEach>

                            <c:if test="${page.pageNumber==page.total}">
                                <li class="disabled" class="nextPage">
                                    <a href="#" aria-label="Next">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                            <c:if test="${page.pageNumber!=page.total}">
                                <li>
                                    <a href="#" aria-label="Next" class="nextPage">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                            <li><a href="get_room_order_page?pageNumber=${page.total}">尾页</a></li>
                        </ul>
                    </nav>
                </div>
            </div><!-- /.panel panel-success -->
        </div><!-- /.dept_info -->
    </div><!-- /.hrms_dept_body -->

    <!-- 尾部-->
    <%@ include file="/WEB-INF/commom/foot.jsp"%>

</div><!-- /.hrms_dept_container -->

<script type="text/javascript">
    var pageNumber = ${page.pageNumber};
    var total = ${page.total};
    //上一页
    $(".prePage").click(function () {
         if (pageNumber > 1){
             var pageNo = pageNumber - 1;
             $(this).attr("href", "get_room_order_page?pageNumber="+pageNo);
         }
    });
    //下一页
    $(".nextPage").click(function () {
        if (pageNumber < total){
            var pageNo = pageNumber + 1;
            $(this).attr("href", "get_room_order_page?pageNumber="+pageNo);
        }
    });
    //删除
    $(".order_delete_btn").click(function () {
        var delRoomOrderDetailNum = $(this).parent().parent().find("td:eq(0)").text();
        var delOrderId = $(this).parent().parent().find("td:eq(1)").text();
        var pageNumber = ${page.pageNumber};
        if (confirm("确认删除订单编号为【"+ delOrderId +"】的信息吗？")){
        	$.post("del_room_order_byid?roomOrderDetailNum="+delRoomOrderDetailNum,function(result){
        		 if (result.code == 200){
                     alert(result.msg);
                     window.location.href="get_room_order_page?pageNumber="+pageNumber;
                 }else {
                     alert(result.msg);
                 }
        	})
        }
    });
</script>
</body>
</html>
