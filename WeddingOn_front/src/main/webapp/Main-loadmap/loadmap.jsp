<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로드맵</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #FFF7FA;
            text-align: center;
            margin: 0;
            padding: 0;
        }

        .header {
            margin-top: 30px;
            font-size: 25px;
            font-weight: bold;
            color: #333;
        }

        .loadmap-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .loadmap-img {
            width: 80%;
            max-width: 1150px; /* 이미지 크기를 적당히 제한 */
            height: auto;
            margin-top: 30px;
        }

        .description {
            margin-top: 10px;
            font-size: 16px;
            color: #555;
        }
    </style>
</head>
<body>
    <div class="header">당신의 특별한 날을 위한 여정이 시작됩니다!</div>
    <div class="loadmap-container">
        <img class="loadmap-img" src="../images/loadmap.png" alt="로드맵 이미지">
    </div>
</body>
</html>
