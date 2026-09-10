- cai dat fcitx5 can vao fcitx5-configtool va them unikey vao
- phim tat chuyen doi ngon ngu la ctrl + space

----
- Cài đặt ssh thì file privatekey phải chạy ở mod 0600 
- Chỉ cần copy file config qua là có thể connect

---
Cài đặt noip-duc
```
https://hub.docker.com/r/noipcom/noip-duc
```

Create an .env file (e.g. noip-duc.env) in a secure location with your No-IP credentials:

```
# noip-duc.env with DDNS Key
NOIP_USERNAME=DdnsKeyUser
NOIP_PASSWORD=DdnsKeyPass
NOIP_HOSTNAMES=all.ddnskey.com
```

docker run -d --env-file noip-duc.env --name noip-duc ghcr.io/noipcom/noip-duc:latest


----
Login vào github có thể dụng gh

```
gh auth login
```

Để fix lỗi mount trên ssd có thể sử dụng các câu lệnh sau:
```
sudo ntfsfix /dev/sda1
```

Sau đó tạo một folder `/mnt/<<Name>>`: 
```
# mount thui
sudo mount -o force /dev/sda1 /mnt/<<Name>>
```

