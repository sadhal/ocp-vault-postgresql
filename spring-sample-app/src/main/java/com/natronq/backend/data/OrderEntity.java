package com.natronq.backend.data;

import lombok.Data;
import lombok.Generated;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.CreationTimestamp;

@Entity
@Table(name = "orders")
@Data
public class OrderEntity {
	@Id
	@GeneratedValue(strategy=GenerationType.IDENTITY)
	@Generated
	private Long id;
	@Column(name = "customer_name")
	private String customerName;
	@Column(name = "product_name")
	private String productName;
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "order_date")
	@CreationTimestamp
	private Date orderDate;
}
