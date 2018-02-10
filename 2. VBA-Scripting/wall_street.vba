Sub wall_street()
Dim Total_Stock_Volume As Double
Dim LastRow As Long
Dim LastRowSum As Long
Dim Ticker As String
Dim count As Long
Dim first_open As Long
Dim Yearly_Change As Double
Dim Perc_Change As Double
Dim Year_Open As Double
Dim Year_Close As Double
Dim IncreaseVal As Double
Dim DecreaseVal As Double
Dim Greatest_Total_Volume As Double

    'run the loop on each worksheet
    For Each ws In Worksheets
    
        'determine the last row of the worksheet
        LastRow = ws.Cells(Rows.count, 1).End(xlUp).Row
            
        'determine the header of the summary information
        'easy assignment
        ws.Range("I1").Value = "Ticker"
        ws.Range("L1").Value = "Total Stock Value"
        'medium assignment
        ws.Range("J1").Value = "Yearly Change"
        ws.Range("K1").Value = "% Change"
            
        'setting the changing row of the summary table where to print my result
        count = 2
        
        'setting the count of the total stock volume to zero
        Total_Stock_Volume = 0
        
        'setting the first year open value for the year change calculation
        first_open = 2
        
        'setting the percentage change to zero
        Perc_Change = 0
        
                'starting the for loop
                For i = 2 To LastRow
                
                    'with an if statement I am going to determine if the ticker is the same in the first column
                    If ws.Cells(i + 1, 1).Value <> ws.Cells(i, 1).Value Then
                        
                        'set the ticker column
                        Ticker = ws.Cells(i, 1).Value
                    
                        'print the ticker symbol
                        ws.Range("I" & count).Value = Ticker
                        
                        'calculating the total stock volume
                        Total_Stock_Volume = Total_Stock_Volume + ws.Cells(i, 7).Value
                        
                        'printing the total stock volume
                        ws.Range("L" & count).Value = Total_Stock_Volume
                        
                        'set the year open value
                        Year_Open = ws.Range("C" & first_open)
                        
                        'set the year close value
                        Year_Close = ws.Range("F" & i)
                        
                        'calculating the yearly change
                        Yearly_Change = Year_Close - Year_Open
                        
                        'printing the yearly change result
                        ws.Range("J" & count).Value = Yearly_Change
                        
                        'calculating the percentage of the change
                        If Year_Open <> 0 Then
                            
                            Perc_Change = (Yearly_Change / Year_Open)
                            
                            'setting up the format and the print place of the % calculation
                            ws.Range("K" & count).NumberFormat = "+0.00%;-0.00%"
                            ws.Range("K" & count).Value = Perc_Change
                                
                        Else
                                                    
                            Perc_Change = 0
                            
                        End If
                        
                            'adding the conditional formatting for the yearly change
                            If ws.Range("J" & count).Value >= 0 Then
                                
                                ws.Range("J" & count).Interior.ColorIndex = 4
                            
                            Else
                                
                                ws.Range("J" & count).Interior.ColorIndex = 3
                            
                            End If
                        
                        
                        'I need to add one row to the table to add the next result
                        count = count + 1
                        
                        'I need to set the following year open amount to the following ticker
                        first_open = i + 1
                        
                        'before exciting the if statement I need to reset the count for the next ticker
                        Total_Stock_Volume = 0
                        Perc_Change = 0
                        
                    'if the cells right after has the same ticker
                    Else
                        
                            Total_Stock_Volume = Total_Stock_Volume + ws.Cells(i, 7).Value
                            
                            Yearly_Change = ws.Cells(i, 6).Value - ws.Cells(i, 3).Value
                    
                    End If
                    
                Next i
    
        'need to determine the greatest increase, decrease and total volume
        
        'determine the last row of the summary table
        LastRowSum = ws.Cells(Rows.count, 9).End(xlUp).Row
        
        'determine the heather of the summary info and format
        ws.Range("O1").Value = "Ticker"
        ws.Range("P1").Value = "Value"
        ws.Range("N2").Value = "Greatest % Increase"
        ws.Range("N3").Value = "Greatest % Decrease"
        ws.Range("N4").Value = "Greatest Total Volume"
        
        'set initial volumes to 0
        IncreaseVal = 0
        DecreaseVal = 0
        Total_Greatest_Volume = 0
        
        For j = 2 To LastRowSum
        
            If ws.Range("K" & j).Value > IncreaseVal Then
            
                IncreaseVal = ws.Range("K" & j).Value
                
                'print cells and format
                ws.Range("O2").Value = ws.Cells(j, 9).Value
                ws.Range("P2").NumberFormat = "+0.00%;-0.00%"
                ws.Range("P2").Value = IncreaseVal
            
            End If
            
             If ws.Range("K" & j).Value < DecreaseVal Then
            
                DecreaseVal = ws.Range("K" & j).Value
                
                'print cells and format
                ws.Range("O3").Value = ws.Cells(j, 9).Value
                ws.Range("P3").NumberFormat = "+0.00%;-0.00%"
                ws.Range("P3").Value = DecreaseVal
            
            End If
            
            If ws.Range("L" & j).Value > Greatest_Total_Volume Then
            
                Greatest_Total_Volume = ws.Range("L" & j).Value
                
                'print cells and format
                ws.Range("O4").Value = ws.Cells(j, 9).Value
                ws.Range("P4").Value = Greatest_Total_Volume
            
            End If
            
        Next j
        
    Next ws
    
End Sub
