<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
   <meta charset="UTF-8">
   <title>database check</title>
   <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
   <style>
      body {
         padding: 20px;
      }
      .data-card {
         margin-bottom: 20px;
         border-radius: 10px;
         box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      }
      .data-header {
         background-color: #f8f9fa;
         padding: 15px;
         border-radius: 10px 10px 0 0;
         border-bottom: 1px solid #dee2e6;
      }
      .data-body {
         padding: 15px;
         max-height: 400px;
         overflow-y: auto;
      }
      .data-footer {
         padding: 10px 15px;
         background-color: #f8f9fa;
         border-top: 1px solid #dee2e6;
         border-radius: 0 0 10px 10px;
      }
      .data-table {
         width: 100%;
      }
      .data-table th {
         position: sticky;
         top: 0;
         background-color: #f8f9fa;
      }
   </style>
</head>
<body>
   <div class="container-fluid">
      <h1 class="mb-4">database check tool</h1>
      
      <div class="row mb-4">
         <div class="col-md-6">
            <div class="card data-card">
               <div class="card-header data-header d-flex justify-content-between align-items-center">
                  <h5 class="mb-0">data loading status</h5>
                  <button class="btn btn-primary btn-sm" id="refreshStatus">refresh</button>
               </div>
               <div class="card-body">
                  <ul class="list-group">
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        stock details data
                        <span class="badge bg-primary rounded-pill" id="stockDetailsCount">
                           <c:out value="${stockDetailsCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        stock price data
                        <span class="badge bg-primary rounded-pill" id="priceDataCount">
                           <c:out value="${priceDataCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        stock basic information
                        <span class="badge bg-primary rounded-pill" id="stocksCount">
                           <c:out value="${stocksCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        user data
                        <span class="badge bg-primary rounded-pill" id="usersCount">
                           <c:out value="${usersCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        portfolio data
                        <span class="badge bg-primary rounded-pill" id="portfoliosCount">
                           <c:out value="${portfoliosCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        user preference data
                        <span class="badge bg-primary rounded-pill" id="preferencesCount">
                           <c:out value="${preferencesCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        user industry preference
                        <span class="badge bg-primary rounded-pill" id="industriesCount">
                           <c:out value="${industriesCount}" default="not loaded"/>
                        </span>
                     </li>
                     <li class="list-group-item d-flex justify-content-between align-items-center">
                        user favorites
                        <span class="badge bg-primary rounded-pill" id="favoritesCount">
                           <c:out value="${favoritesCount}" default="not loaded"/>
                        </span>
                     </li>
                  </ul>
               </div>
               <div class="card-footer data-footer">
                  <a href="/loadData" class="btn btn-success w-100" onclick="return confirm('are you sure to load all data? it may take some time');">load all data</a>
               </div>
            </div>
         </div>
         
         <div class="col-md-6">
            <div class="card data-card">
               <div class="card-header data-header">
                  <h5 class="mb-0">database table selection</h5>
               </div>
               <div class="card-body">
                  <form action="/checkData" method="get" id="tableSelectForm">
                     <div class="mb-3">
                        <label for="tableName" class="form-label">select the table to view:</label>
                        <select class="form-select" id="tableName" name="tableName" required>
                           <option value="" selected disabled>please select a table</option>
                           <option value="stock_details">stock details (stock_details)</option>
                           <option value="price_data">stock price data (price_data)</option>
                           <option value="stocks">stock basic information (stocks)</option>
                           <option value="users">user (users)</option>
                           <option value="portfolios">portfolio (portfolios)</option>
                           <option value="user_preferences">user preference (user_preferences)</option>
                           <option value="user_industries">user industry preference (user_industries)</option>
                           <option value="user_favorites">user favorites (user_favorites)</option>
                        </select>
                     </div>
                     <div class="mb-3">
                        <label for="limit" class="form-label">display record number:</label>
                        <input type="number" class="form-control" id="limit" name="limit" min="1" max="100" value="10">
                     </div>
                     <button type="submit" class="btn btn-primary w-100">view data</button>
                  </form>
               </div>
            </div>
         </div>
      </div>
      
      <c:if test="${not empty tableData}">
         <div class="card data-card">
            <div class="card-header data-header d-flex justify-content-between align-items-center">
               <h5 class="mb-0">${selectedTable} table data (display ${tableData.size()} records)</h5>
               <div>
                  <a href="/exportTableData?tableName=${selectedTable}" class="btn btn-secondary btn-sm me-2">export CSV</a>
                  <button class="btn btn-primary btn-sm" id="refreshTable">refresh</button>
               </div>
            </div>
            <div class="card-body data-body">
               <div class="table-responsive">
                  <table class="table table-striped table-hover data-table">
                     <thead>
                        <tr>
                           <c:forEach var="column" items="${tableColumns}">
                              <th>${column}</th>
                           </c:forEach>
                        </tr>
                     </thead>
                     <tbody>
                        <c:forEach var="row" items="${tableData}">
                           <tr>
                              <c:forEach var="cell" items="${row}">
                                 <td>${cell}</td>
                              </c:forEach>
                           </tr>
                        </c:forEach>
                     </tbody>
                  </table>
               </div>
            </div>
            <div class="card-footer data-footer">
               total records: <strong id="totalRecords">${totalRecords}</strong>
            </div>
         </div>
      </c:if>
   </div>

   <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
   <script>
      document.getElementById('refreshStatus').addEventListener('click', function() {
         window.location.href = '/checkDataStatus';
      });
      
      document.getElementById('refreshTable').addEventListener('click', function() {
         document.getElementById('tableSelectForm').submit();
      });
   </script>
</body>
</html> 