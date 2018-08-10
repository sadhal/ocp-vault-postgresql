package com.natronq.backend;

import java.util.Date;

import lombok.Data;

@Data
public class Order {
    private Long id;
    private String customerName;
    private String productName;
    private Date orderDate;
}
