# 📊 UniFi Network Observatory Dashboard Import Guide

## 🎯 **Quick Import Steps**

### **Method 1: Direct File Import (Recommended)**
1. **Login to Grafana**: http://192.168.22.253:3000 (admin/admin123)
2. **Navigate to Import**: Click the "+" icon → Import
3. **Upload JSON**: Click "Upload JSON file"
4. **Select File**: Choose `unifi-network-monitoring.json`
5. **Configure**: 
   - Name: "🌐 UniFi Network Observatory - fing-pi"
   - Folder: General (or create a new folder)
6. **Import**: Click "Import"

### **Method 2: Copy-Paste JSON**
1. **Login to Grafana**: http://192.168.22.253:3000
2. **Navigate to Import**: Click the "+" icon → Import  
3. **Paste JSON**: Copy the entire content of `unifi-network-monitoring.json`
4. **Load**: Click "Load"
5. **Import**: Review settings and click "Import"

## 🔧 **Dashboard Features**

### **📊 What You'll See:**

#### **🌐 Network Overview Section:**
- **Service Health Status**: Pie chart showing all monitoring services
- **Host Metrics**: CPU, Memory, Disk usage gauges  
- **Network Traffic**: Real-time network throughput
- **Container Monitoring**: Docker container resource usage

#### **📊 UniFi Network Data Analysis:**
- **Real-time Device Logs**: Live syslog from UniFi devices
- **Log Rate Analysis**: Messages per minute by device
- **Log Source Distribution**: Which services are logging most
- **Error & Debug Filtering**: Separate panels for troubleshooting

#### **🚦 Network Flow Analysis:**
- **Packet Rate Monitoring**: Packets per second by interface
- **Network Throughput**: Bandwidth utilization bar gauges
- **Error Detection**: Network errors and dropped packets

#### **🔧 Observability Stack Health:**
- **Quick Reference Guide**: Built-in documentation
- **Direct Links**: Quick access to Prometheus and AlertManager
- **Usage Examples**: Sample queries for log analysis

## 🎛️ **Dashboard Configuration**

### **Default Settings:**
- **Refresh Rate**: 30 seconds (auto-refresh)
- **Time Range**: Last 1 hour
- **Theme**: Dark mode (matches your setup)
- **Data Sources**: Pre-configured for Prometheus, Loki, Tempo

### **Customization Options:**
- **Editable**: All panels can be modified
- **Time Ranges**: Adjustable from top-right time picker
- **Variables**: Ready for templating (device names, etc.)
- **Alerts**: Can be added to any panel

## 🔍 **Key Log Queries to Try:**

### **UniFi Device Logs:**
```
{job="unifi"} |= ""
```

### **Error Messages Only:**
```
{job="unifi"} |~ "ERROR|error|Error"
```

### **Debug Messages:**
```
{job="unifi"} |~ "DEBUG|debug|Debug"
```

### **Specific Device:**
```
{hostname=~".*USW.*|.*UAP.*|.*UDM.*|.*USG.*"}
```

### **High Log Rate Detection:**
```
sum(count_over_time({job="unifi"}[1m])) by (hostname) > 10
```

## 🚀 **Performance Tips**

1. **Time Range**: Use shorter ranges (1-6 hours) for better performance
2. **Log Filtering**: Apply filters to reduce query load
3. **Panel Refresh**: Adjust individual panel refresh rates if needed
4. **Browser**: Use Chrome/Firefox for best performance

## 🔗 **Quick Access URLs**

After importing, bookmark these:

- **Main Dashboard**: http://192.168.22.253:3000/d/unifi-fing-pi-dashboard
- **Explore Logs**: http://192.168.22.253:3000/explore (Select Loki)
- **Prometheus**: http://192.168.22.253:9090
- **AlertManager**: http://192.168.22.253:9093

## 🎨 **Dashboard Customization**

### **Adding New Panels:**
1. Click "Add Panel" (top toolbar)
2. Select data source (Prometheus/Loki)
3. Write your query
4. Configure visualization
5. Save dashboard

### **Color Themes:**
- Dashboard uses consistent color palette
- Green = Good/Normal
- Yellow = Warning
- Red = Critical/Error

### **Layout Sections:**
1. **Overview**: System health and key metrics
2. **UniFi Analysis**: Device-specific monitoring  
3. **Network Flow**: Traffic analysis
4. **Stack Health**: Monitoring infrastructure status

## ⚠️ **Troubleshooting**

### **No Data Showing:**
- Check if UniFi devices are sending logs (Controller settings)
- Verify syslog is reaching port 514: `netstat -tulnp | grep 514`
- Check Loki data source connection in Grafana

### **Performance Issues:**
- Reduce time range (try last 30 minutes)
- Add more specific log filters
- Check if all services are running: `docker ps`

### **Import Errors:**
- Ensure data sources are named exactly: "Prometheus", "Loki"
- Check Grafana version compatibility
- Verify JSON file is complete and valid

---

**🎉 Your UniFi Network Observatory dashboard is ready to provide comprehensive network insights!**
